require "test_helper"
require "throttle"

class ThrottleTest < ActiveSupport::TestCase
  test "sanity" do
    duration = 0.1.second
    throttle = Throttle.new(duration)

    count = 0
    start_at = Time.now

    threads = 5.times.map do
      Thread.new do
        5.times do
          throttle.call { count += 1 }
        end
      end
    end

    threads.each(&:join)
    actual_elapsed = Time.now - start_at
    expected_elapsed = 25 * duration * 0.99 # fudge factor

    assert_equal 25, count
    assert actual_elapsed >= expected_elapsed, "Expected >=#{expected_elapsed} seconds to elapse, but was #{actual_elapsed}"
  end
end
