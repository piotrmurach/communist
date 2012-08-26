require 'socket'
require 'thread'
require 'sinatra/base'
require 'net/http'
require 'communist'

module Communist
  class Server

    class ServerError < StandardError; end

    class Identify
      def initialize(app)
        @app = app
      end

      def call(env)
        if env["PATH_INFO"] == "/__identify__"
          [200, {}, [@app.object_id.to_s]]
        else
          @app.call(env)
        end
      end
    end

    class << self
      def ports
        @ports ||= {}
      end
    end

    attr_reader :app, :port, :host

    def initialize(app, options={})
      @app  = app
      @port = options[:port] || Communist.server_port
      @host = options[:host]
      @server_thread = nil
      @port = Communist::Server.ports[@app.object_id]
      @port = find_available_port
    end

    def host
      Communist.server_host || "127.0.0.1"
    end

    def responsive?
      return false if @server_thread && @server_thread.join(0)

      res = Net::HTTP.start(host, @port) { |http| http.get('/__identify__') }

      if res.is_a?(Net::HTTPSuccess) or res.is_a?(Net::HTTPRedirection)
        return res.body == app.object_id.to_s
      end
    rescue Errno::ECONNREFUSED, Errno::EBADF
      return false
    end

    def start(&block)
      raise ArgumentError, 'app required' unless app

      unless responsive?
        Communist::Server.ports[app.object_id] = port

        @server_thread = Thread.new do
          Communist.run_default_server(Identify.new(app), port) do |server|
            Communist.server = server
            trap "INT" do server.shutdown end
          end
        end

        Timeout.timeout(60) { @server_thread.join(0.1) until responsive? }
      end
    rescue TimeoutError
      raise ServerError, "Rack application timed out during start"
    else
      self
    end

    # Stops the server after handling the connection.
    # Attempts to stop the server gracefully, otherwise
    # shuts current connection right away.
    def stop
      if Communist.server.respond_to?(:shutdown)
        Communist.server.shutdown
      elsif Communist.server.respond_to?(:stop!)
        Communist.server.stop!
      else
        Communist.server.stop
      end
      @server_thread.join
    end

    def self.run(&block)
      app = Sinatra.new do
        set :show_exceptions, true
        set :environment, :test
        disable :protection

        self.class_eval(&block)

        helpers do
          def body(value=nil)
            super
            nil
          end
        end
      end

      new(app).start
    end

  private

    def find_available_port
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[Socket::Constants::SOCK_STREAM]
    ensure
      server.close if server
    end

  end # Server
end # Communist
