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
gem "elasticsearch", "~> 7.0"
gem "bcrypt"
gem "jwt"
gem "strong_password"
gem "mailgun_rails"

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
