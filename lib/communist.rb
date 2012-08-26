require 'communist/version'
require 'rack'

module Communist

  class CommunistError < StandardError; end

  class << self
    attr_accessor :app_host
    attr_accessor :default_host
    attr_accessor :server_host, :server_port
    attr_accessor :run_server
    attr_accessor :app

    # Configure Communist options
    #
    #  Communist.configure do |config|
    #    config.server_host = 'http://localhost'
    #  end
    #
    def configure
      yield self
    end

    def server=(instance)
      @server = instance
    end

    def server(&block)
      if block_given?
        @server = block
      else
        @server
      end
    end

    # Stores server instances.
    #
    def servers
      @servers ||= {}
    end

    # By default run thin or fall back on webrick
    #
    def run_default_server(app, port, &block)
      begin
        require 'rack/handler/thin'
        Thin::Logging.silent = true
        Rack::Handler::Thin.run(app, :Port => port, &block)
      rescue LoadError
        require 'rack/handler/webrick'
        Rack::Handler::WEBrick.run(app, :Port => port, :AccessLog => [], :Logger => WEBrick::Log::new(nil, 0), &block)
      end
    end

  end

  autoload :Server,     'communist/server'
  autoload :Const,      'communist/const'
  autoload :NullServer, 'communist/null_server'

end # Communist

Communist.configure do |config|
end
