ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "vcr"

require_relative "./factories"

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors, with: :threads)

  setup do
    PaperTrail.enabled = false
    Searchkick.disable_callbacks
  end

  teardown do
    Search::MODELS.each do |m|
      m.search_index.delete rescue nil
    end
  end

  def with_search(*models, &block)
    Search.reindex(*models)
    Searchkick.callbacks(true, &block)
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.ignore_hosts "chromedriver.storage.googleapis.com"

  # Run specs with `VCR=all` or `VCR=new_episodes` to record new cassettes
  config.default_cassette_options = {record: ENV["VCR"] ? ENV["VCR"].to_sym : :once}

  config.filter_sensitive_data("<APIKEY>") { LookupMetadata::API_KEY }
end
