ENV["MOTOR_AUTH_USERNAME"] = ENV["ADMIN_USER"]
ENV["MOTOR_AUTH_PASSWORD"] = ENV["ADMIN_PASS"]

Rails.application.config.to_prepare do
  ENV["MOTOR_ALERTS_FROM_ADDRESS"] = ApplicationMailer::SUPPORT_FROM
end
