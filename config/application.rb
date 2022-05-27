require_relative "boot"

require "rails/all"
require "good_job/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Chords
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

    config.action_mailer.default_url_options = {
      host: ENV.fetch("APP_HOSTNAME", "localhost:3000")
    }
    config.action_mailer.deliver_later_queue_name = :high
  end
end
