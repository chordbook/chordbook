require "test_helper"

class UpdateRankTest < ActiveJob::TestCase
  test "ranks songsheets by plays" do
    played_many = create :songsheet
    unplayed = create :songsheet
    played_once = create :songsheet

    play played_many, times: 2
    play played_once

    UpdateRank.new.perform

    assert_equal 1, played_many.reload.rank
    assert_equal 2, played_once.reload.rank
    assert_equal 3, unplayed.reload.rank
  end

  test "ranks tracks by songsheet plays, listeners" do
    listeners = create :track, listeners: 1_000_000
    no_listeners = create :track, listeners: nil
    played_many = create :songsheet, track: create(:track)
    played_once = create :songsheet, track: create(:track)
    played_never = create :songsheet, track: create(:track)

    play played_many, times: 2
    play played_once

    UpdateRank.new.perform

    assert_equal 1, played_many.track.reload.rank
    assert_equal 2, played_once.track.reload.rank
    assert_equal 3, played_never.track.reload.rank
    assert_equal 4, listeners.reload.rank
    assert_equal 5, no_listeners.reload.rank
  end

  test "ranks albums by avg track rank" do
    high_avg = create :album, tracks: [
      create(:track, rank: 1),
      create(:track, rank: 5),
      create(:track, rank: 10),
      create(:track, rank: 31)
    ]

    low_avg = create :album, tracks: [
      create(:track, rank: 20),
      create(:track, rank: 30),
      create(:track, rank: 40),
      create(:track, rank: 50)
    ]

    UpdateRank.new.rank_albums

    assert_equal 1, high_avg.reload.rank
    assert_equal 2, low_avg.reload.rank
  end

  test "ranks artists by songsheet players" do
    popular = create :artist
    less_popular = create :artist
    listeners = create :artist, listeners: 1000
    no_listeners = create :artist, listeners: nil

    # 3 songsheets with the same 2 players each
    create(:songsheet, artists: [less_popular]).tap { |s| play s, times: 2 }
    create(:songsheet, artists: [less_popular]).tap { |s| play s, times: 2 }
    create(:songsheet, artists: [less_popular]).tap { |s| play s, times: 2 }

    # One songsheet with 5 players
    create(:songsheet, artists: [popular]).tap { |s| play s, times: 5 }

    UpdateRank.new.rank_artists

    assert_equal 1, popular.reload.rank
    assert_equal 2, less_popular.reload.rank
    assert_equal 3, listeners.reload.rank
    assert_equal 4, no_listeners.reload.rank
  end

  test "ranks generes by songsheet players" do
    popular = create :genre
    less_popular = create :genre
    listeners = create :genre, listeners: 1000
    no_listeners = create :genre, listeners: nil

    # 3 songsheets with the same 2 players each
    create(:songsheet, track: create(:track, genre: less_popular)).tap { |s| play s, times: 2 }
    create(:songsheet, track: create(:track, genre: less_popular)).tap { |s| play s, times: 2 }
    create(:songsheet, track: create(:track, genre: less_popular)).tap { |s| play s, times: 2 }

    # One songsheet with 5 players
    create(:songsheet, track: create(:track, genre: popular)).tap { |s| play s, times: 5 }

    UpdateRank.new.rank_genres

    assert_equal 1, popular.reload.rank
    assert_equal 2, less_popular.reload.rank
    assert_equal 3, listeners.reload.rank
    assert_equal 4, no_listeners.reload.rank
  end

  test "ranks setlists by avg songsheet rank" do
    first = create :setlist, songsheets: [create(:songsheet, rank: 1)]
    third = create :setlist, songsheets: [create(:songsheet, rank: 3)]
    second = create :setlist, songsheets: [create(:songsheet, rank: 2)]

    UpdateRank.new.rank_setlists

    assert_equal 1, first.reload.rank
    assert_equal 2, second.reload.rank
    assert_equal 3, third.reload.rank
  end

  def play(songsheet, at: Time.now, times: 1)
    @users ||= {}
    times.times do |i|
      user = @users[i] ||= create(:user)
      visit = Ahoy::Visit.create! user: user
      Ahoy::Event.create!(
        visit: visit,
        user: user,
        name: "play",
        properties: {songsheet_id: songsheet.id},
        time: at
      )
    end
  end
end
