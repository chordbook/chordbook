require "test_helper"

class DurationTest < ActiveSupport::TestCase
  test "parses mm:ss" do
    assert_equal 0, Duration.parse("0:00").usec
    assert_equal 193000, Duration.parse("3:13").usec
    assert_equal 71100, Duration.parse("1:11.1").usec
    assert_equal 703000, Duration.parse("11:43").usec
  end

  test "parses string of seconds" do
    assert_equal 120000, Duration.parse("120").usec
  end

  test "parses as float" do
    assert_equal 120395, Duration.parse(120.395).usec
  end
end
