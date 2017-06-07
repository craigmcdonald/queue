require 'pry'
require 'simplecov'
SimpleCov.start
ENV['ORDERLY_ENV'] = 'test'
ENV['ORDERLY_TEST_DIR'] = "#{__dir__}/fixtures"
ENV['ORDERLY_TEST_CONF'] = ENV['ORDERLY_TEST_DIR'] + '/config.yaml'
Dir["#{__dir__.gsub('/spec','')}#{'/lib/*.rb'}"].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  config.default_formatter = "doc" if config.files_to_run.one?
end
