require 'communist/server'

Before do
  ENV['TEST_HOST'] = '127.0.0.1:0'
end

After do
  @server.stop if defined? @server and @server
end

Given /^the (.*) server:$/ do |name, endpoints|
  @server = ::Communist::Server.run do
    eval endpoints, binding
  end

  ENV['TEST_HOST'] = "127.0.0.1:#{@server.port}"
end
