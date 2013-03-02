require 'socket'
require 'thread'
require 'sinatra/base'
require 'net/http'
require 'communist'
require 'json'

module Communist
  class Server

    include Communist::Const

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
      @host = options[:host]
      @server_thread = nil
      @port = options[:port] || Communist.server_port
      @port ||= Communist::Server.ports[@app.object_id]
      @port ||= find_available_port
    end

    def host
      Communist.server_host || DEFAULT_HOST
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
            Communist.servers[app.object_id] = server
          end
        end

        Timeout.timeout(DEFAULT_TIMEOUT) { @server_thread.join(0.1) until responsive? }
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
      server = Communist.servers.delete(app.object_id) { |s| NullServer.new }
      if Communist.server.respond_to?(:shutdown)
        server.shutdown
      elsif Communist.server.respond_to?(:stop!)
        server.stop!
      else
        server.stop
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

          def json(value)
            content_type :json
            JSON.generate value
          end
        end

        after do
          if !response.body.empty?
            content_type :json
            body JSON.generate(response.body)
          end
        end
      end

      new(app).start
    end

  private

    def find_available_port
      server = TCPServer.new(DEFAULT_HOST, 0)
      server.addr[Socket::Constants::SOCK_STREAM]
    ensure
      server.close if server
    end

  end # Server
end # Communist
