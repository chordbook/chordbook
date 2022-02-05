if Rails.env.production?
  GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(ENV.fetch("ADMIN_USER"), username) &&
      ActiveSupport::SecurityUtils.secure_compare(ENV.fetch("ADMIN_PASS"), password)
  end
end

Rails.application.configure do
  config.good_job.queues = 'default,low,*'
end
