require "test_helper"

class ReferenceTest < ActiveSupport::TestCase
  test "data= merges values" do
    reference = Reference.new(data: {a: 1, b: 2})
    reference.data = {"b" => 2, :c => 3}
    assert_equal({a: 1, b: 2, c: 3}.with_indifferent_access, reference.data)
  end
end
