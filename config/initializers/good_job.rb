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
    cleanup_searches: {cron: "every day", class: "CleanupSearchesJob"},
    cleanup_tokens: {cron: "every day", class: "CleanupTokens"},
    generated_setlists: {cron: "every day", class: "GeneratedSetlists"},
    opt_outs: {cron: "every day", class: "PerformableMethod", args: [Mailkick, :fetch_opt_outs]},
    update_listeners: {cron: "every day", class: "UpdateListenerCounts"},
    update_rank: {cron: "every day", class: "UpdateRank"},
    youtube_lookup: {cron: "every day", class: "PerformableMethod", args: -> { [YoutubeLookup, :top_tracks] }}
  }
end
