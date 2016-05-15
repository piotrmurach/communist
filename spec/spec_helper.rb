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
  config.include Helpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Limits the available syntax to the non-monkey patched syntax that is recommended.
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 2

  config.order = :random

  Kernel.srand config.seed
end
