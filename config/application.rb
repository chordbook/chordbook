require_relative "boot"

require "rails/all"
require "good_job/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChordBook
  API_URI = URI(ENV.fetch("APP_API_URL", "http://localhost:3100"))
  CLIENT_URI = begin
    host = ENV.fetch("APP_HOSTNAME", "http://localhost:3000")
    host = "https://#{host}" unless host.starts_with?("http")
    URI(host)
  end

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_job.queue_adapter = :good_job

    # Load routes from engine before app
    config.railties_order = [:all, :main_app]

    config.active_record.schema_format = :sql
    config.action_mailer.default_url_options = {host: API_URI.host, port: API_URI.port}
    config.action_mailer.deliver_later_queue_name = :high

    config.middleware.use Rack::Deflater
  end
end
