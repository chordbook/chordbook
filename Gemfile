source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails"
gem "pg"
gem "puma"
gem "bootsnap", ">= 1.4.4", require: false
gem "jbuilder"
gem "httparty"
gem "pg_search"
gem "good_job"
gem "rack-cors"
gem "nokogiri"
gem "chordpro", git: "https://github.com/bkeepers/chordpro.git", branch: "carriage-returns"
gem "kaminari"
gem "addressable"
gem "acts_as_list"
gem "paper_trail"
gem "searchkick"
gem "elasticsearch", "~> 7.17"
gem "bcrypt"
gem "jwt"
gem "strong_password"
gem "mailgun-ruby"
gem "mailgun_rails"
gem "mailkick"
gem "actionpack-page_caching"
gem "ahoy_matey"
gem "motor-admin"
gem "shortuuid"
gem "google-apis-youtube_v3"
gem "image_processing"
gem "aws-sdk-s3"
gem "sentry-ruby"
gem "sentry-rails"

group :development, :test do
  gem "debug"
  gem "standard"
  gem "dotenv-rails"
  gem "guard", require: false
  gem "guard-minitest", require: false
  gem "guard-shell", require: false
end

group :development do
  gem "web-console"
  gem "listen"
  gem "letter_opener"
  gem "charlock_holmes", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "vcr"
  gem "webmock"
  gem "factory_bot"
  gem "faker"
end
