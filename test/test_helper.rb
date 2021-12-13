ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'vcr'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr"
  config.hook_into :webmock

  # Run specs with `VCR=all` or `VCR=new_episodes` to record new cassettes
  config.default_cassette_options = {record: ENV["VCR"] ? ENV["VCR"].to_sym : :once}

  config.filter_sensitive_data("<APIKEY>") { LookupMetadata::API_KEY }
end
