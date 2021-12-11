require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  # Enable forgery protection for system tests
  setup do
    ActionController::Base.allow_forgery_protection = true
  end

  # Restore forgery protection for other tests
  teardown do
    assert_no_js_errors(false)
    assert_no_console_messages
    ActionController::Base.allow_forgery_protection = false
  end

  def assert_no_js_errors(verify_tracking = true)
    errors = JSON.parse(evaluate_script("JSON.stringify(window.errors || false)"))

    if verify_tracking
      assert errors.is_a?(Array), "Error tracking not working. Make sure `errors.js` is loaded in tests"
    end
    assert errors.empty?, errors.map { |error| error["stack"] }.join("\n\n") if errors
  end

  def assert_no_console_messages(level = nil) # "SEVERE"
    logs = page.driver.browser.logs.get(:browser)
    logs = logs.select { |log| log.level == level } if level
    assert logs.empty?, "Unexpected console messages:\n" + logs.map(&:message).join("\n\n")
  end
end
