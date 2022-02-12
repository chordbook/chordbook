source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

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

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "standard"
  gem "dotenv-rails"
end

group :development do
  gem "web-console"
  gem "listen"
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
