require 'rubygems'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'communist'

RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true
  config.tty = true
end
