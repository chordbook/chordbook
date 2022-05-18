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

  test "lookup returns verified artists over unverified" do
    with_search Artist do
      create(:artist, name: "Everly Brothers", verified: false)
      expected = create(:artist, name: "The Everly Brothers", verified: true)

      assert_equal expected, Artist.lookup("Everly Brothers")
      assert_equal expected, Artist.lookup("The Everly Brothers")
    end
  end

  test "lookup does not return ridiculous results" do
    with_search Artist do
      create(:artist, name: "Michael Jackson", verified: true)
      assert_nil Artist.lookup("Ingrid Michaelson")

      expected = create(:artist, name: "Ingrid Michaelson", verified: false)
      assert_equal expected, Artist.lookup("Ingrid Michaelson")
    end
  end

  test "lookup finds artist by alternate name" do
    with_search Artist do
      expected = create :artist, name: "Huey Lewis",
        metadata: {"strArtistAlternate" => "Huey Lewis & The News"}

      assert_equal expected, Artist.lookup("Huey Lewis & The News")
    end
  end
end
