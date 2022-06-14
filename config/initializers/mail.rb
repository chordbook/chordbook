if ENV["MAILGUN_API_KEY"]
  Rails.application.configure do
    config.action_mailer.delivery_method = :mailgun
    config.action_mailer.mailgun_settings = {
      api_key: ENV["MAILGUN_API_KEY"],
      domain: ENV["MAILGUN_DOMAIN"]
    }
  end
end
