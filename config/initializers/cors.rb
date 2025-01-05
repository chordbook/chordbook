Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ["localhost:3000", "chordbook.app", %r{\Ahttps://web-pr-\d+\.onrender\.com\z}, ENV["APP_HOSTNAME"]].compact
    resource "*",
      headers: :any,
      methods: [:get, :post, :patch, :put, :delete],
      expose: ["Link", "Access-Token", "Expire-At", "Refresh-Token"],
      credentials: true
  end
end
