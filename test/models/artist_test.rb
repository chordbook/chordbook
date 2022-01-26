require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  test "starts_with finds letter" do
    norah = create :artist, name: "Norah Jones"
    ed = create :artist, name: "Ed Sheeran"
    three = create :artist, name: "3 Doors Down"

    assert_equal Artist.starts_with(:name, "N").to_a, [norah]
    assert_equal Artist.starts_with(:name, "E").to_a, [ed]
    assert_equal Artist.starts_with(:name, "#").to_a, [three]
  end
end
