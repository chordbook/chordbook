require "test_helper"

class GeneratedSetlistsTest < ActiveJob::TestCase
  test "updates setlists" do
    songsheets = 101.times.map { |i| create :songsheet, rank: i + 1 }

    GeneratedSetlists.perform_now

    trending = User.app.setlists.find_by!(title: "Trending")
    assert_equal 100, trending.songsheets.count

    # Update order
    old_1 = songsheets.first
    new_1 = songsheets.last

    old_1.update! rank: 101
    new_1.update! rank: 1

    GeneratedSetlists.perform_now

    assert_equal 100, trending.reload.songsheets.count
    assert_equal new_1, trending.songsheets.first
    refute_includes trending.songsheets, old_1
  end

  test "'Trending' includes top 100 songs by rank" do
    songsheets = 101.times.map { |i| create :songsheet, rank: i + 1 }

    scope = GeneratedSetlists::SETLISTS["Trending"].call
    assert_equal 100, scope.count
    refute_includes scope, songsheets.last
  end

  test "`What's New` includes recently created songsheets" do
    newer = create :songsheet
    older = create :songsheet, created_at: 3.months.ago

    scope = GeneratedSetlists::SETLISTS["What's New"].call

    assert_includes scope, newer
    refute_includes scope, older
  end
end
