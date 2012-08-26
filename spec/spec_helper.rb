require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'communist'

DEFAULT_TEST_HOST = '0.0.0.0'
DEFAULT_TEST_PORT = 3333

module Helpers
  def start_server(app, options, &block)
    @server = Communist::Server.new(app, options)
    @thread = Thread.new { @server.start }
  end

  def stop_server
    @server.stop!
    @thread.kill
  end
end

RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true
  config.tty = true

  config.include Helpers
end
