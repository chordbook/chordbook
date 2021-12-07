require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  # Enable forgery protection for system tests
  setup do
    ActionController::Base.allow_forgery_protection = true
  end

  # Restore forgery protection for other tests
  teardown do
    ActionController::Base.allow_forgery_protection = false
  end
end
