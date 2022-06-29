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

  test "lookup_all with array" do
    with_search Artist do
      artists = [
        create(:artist, name: "Norah Jones"),
        create(:artist, name: "Billie Joe Armstrong")
      ]

      found, unknown = Artist.lookup_all(artists.map(&:name))

      assert_equal found, artists
      assert_equal [], unknown
    end
  end

  test "lookup_all single artist with 'and' in name" do
    with_search Artist do
      artist = create(:artist, name: "Tom Petty and the Heart Breakers")

      found, unknown = Artist.lookup_all(artist.name)

      assert_equal found, [artist]
      assert_equal [], unknown
    end
  end

  test "lookup_all multiple artists with and/&" do
    with_search Artist do
      artists = [
        create(:artist, name: "Johnny Cash"),
        create(:artist, name: "June Carter"),
      ]

      found, unknown = Artist.lookup_all("Johnny Cash and June Carter")
      assert_equal found, artists
      assert_equal [], unknown

      found, unknown = Artist.lookup_all("Johnny Cash & June Carter")
      assert_equal found, artists
      assert_equal [], unknown
    end
  end

  test "lookup_all prefixed with 'by '" do
    with_search Artist do
      artist = create(:artist, name: "Bob Marley")

      found, unknown = Artist.lookup_all('by Bob Marley')
      assert_equal found, [artist]
      assert_equal [], unknown
    end
  end

  test "lookup_all returns all unknown permutations" do
    with_search Artist do
      create :artist, name: "Irrelevant" # needed to initialize search index

      artists, unknown = Artist.lookup_all('Noah and the Whale')
      assert_equal [], artists
      assert_equal ["Noah and the Whale", "Noah", "the Whale"], unknown
    end
  end

  test "lookup_all returns full name if only one part of name is found" do
    with_search Artist do
      artist = create :artist, name: "Tom Petty"

      artists, unknown = Artist.lookup_all('Tom Petty and the Heartbreakers')
      assert_equal [artist], artists
      assert_equal ['Tom Petty and the Heartbreakers', "the Heartbreakers"], unknown
    end
  end
end
