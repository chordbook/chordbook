# https://github.com/ankane/mailkick#bounces-and-spam-reports
Mailkick.process_opt_outs_method = lambda do |opt_outs|
  emails = opt_outs.map { |v| v[:email] }
  subscribers = User.includes(:mailkick_subscriptions).where(email: emails).index_by(&:email)

  opt_outs.each do |opt_out|
    subscriber = subscribers[opt_out[:email]]
    next unless subscriber

    subscriber.mailkick_subscriptions.each do |subscription|
      subscription.destroy if subscription.created_at < opt_out[:time]
    end
  end
end

if ENV["MAILGUN_API_KEY"]
  Mailkick.services = [
    Mailkick::Service::Mailgun.new(api_key: ENV["MAILGUN_API_KEY"], domain: ENV["MAILGUN_DOMAIN"])
  ]
end

# Explicitly set secret from key generator instead of using secret_key_base directly
Mailkick.secret_token = Rails.application.key_generator.generate_key("mailkick")
