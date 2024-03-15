ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "vcr"

require_relative "factories"

Flipper.configure do |config|
  config.default { Flipper.new(Flipper::Adapters::Memory.new) }
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors, with: :threads)

  setup do
    PaperTrail.enabled = false
    Searchkick.disable_callbacks
    Flipper.instance = nil
  end

  teardown do
    Search::MODELS.each do |m|
      m.search_index.delete
    rescue
      nil
    end
  end

  def with_search(*models, &)
    Search.reindex(*models)
    Searchkick.callbacks(true, &)
  end

  def token_headers(user)
    create(:access_token, user: user).request_headers
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
  config.filter_sensitive_data("<YOUTUBE-API-KEY>") { YoutubeLookup::API_KEY }
end
