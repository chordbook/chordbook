if Rails.env.production?
  GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(ENV.fetch("ADMIN_USER"), username) &&
      ActiveSupport::SecurityUtils.secure_compare(ENV.fetch("ADMIN_PASS"), password)
  end
end

Rails.application.configure do
  config.good_job.queues = "metadata:1;high,searchkick,default,low,-metadata"
  config.good_job.enable_cron = true
  config.good_job.cron = {
    listeners: {cron: "every day", class: "UpdateListenerCounts"},
    rank: {cron: "every day", class: "UpdateRank"},
    tokens: {cron: "every day", class: "CleanupTokens"},
    opt_outs: {cron: "every day", class: "PerformableMethod", args: [Mailkick, :fetch_opt_outs]},
    generated_setlists: {cron: "every day", class: "GeneratedSetlists"},
  }
end
