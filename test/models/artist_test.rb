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

  test "name_like orders verified artists before unverified" do
    expected = [
      create(:artist, name: "The Everly Brothers", verified: true),
      create(:artist, name: "Everly Brothers", verified: false)
    ]

    results = Artist.name_like("Everly Brothers").with_pg_search_rank

    assert_equal expected[0], results[0]
    assert_in_delta results[0].pg_search_rank, 0.85, 0.1

    assert_equal expected[1], results[1]
    assert_in_delta results[0].pg_search_rank, 0.75, 0.1
  end
end
