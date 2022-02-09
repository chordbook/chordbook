require "test_helper"

class Import::OzbcozTest < ActiveJob::TestCase
  test "all" do
    VCR.use_cassette("ozbcoz") do
      assert_enqueued_jobs 3322 do
        Import::Ozbcoz.all
      end
    end
  end

  test "perform" do
    assert_difference -> { Songsheet.count } do
      songsheet = import "https://ozbcoz.com/Songs/guitarpdf/pro/Across-The-Universe.pro"

      assert_equal "Across The Universe", songsheet.title
      assert_equal({"artist" => "The Beatles", "key" => "C"}, songsheet.metadata)
    end
  end

  test "song with bad encoding" do
    assert_difference -> { Songsheet.count } do
      songsheet = import "https://ozbcoz.com/Songs/guitarpdf/pro/Aint-No-Cure-For-Love.pro"
      assert_equal "Ain’t No Cure For Love", songsheet.title
    end
  end

  test "removes key from title" do
    songsheet = import "https://ozbcoz.com/Songs/guitarpdf/pro/Act-Naturally-C.pro"
    assert_equal "Act Naturally", songsheet.title
  end

  test "removes '- Alt` from title, moves definite article" do
    songsheet = import "https://ozbcoz.com/Songs/guitarpdf/pro/Yellow-Rose-Of-Texas-The--Alt.pro"
    assert_equal "The Yellow Rose Of Texas", songsheet.title
  end

  test "removes emdash from title" do
    songsheet = import "https://ozbcoz.com/Songs/guitarpdf/pro/Only-You--Yazoo--F.pro"
    assert_equal "Only You", songsheet.title
  end

  def import(url)
    VCR.use_cassette("ozbcoz") do
      perform_enqueued_jobs only: Import::Chordpro do
        Import::Ozbcoz.perform_now(url)
      end
    end
    Songsheet.find_by(imported_from: url)
  end
end
