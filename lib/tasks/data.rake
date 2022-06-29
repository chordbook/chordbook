def track_info(track)
  return unless track

  "#{track.title} (#{track.listeners}) - by #{track.artist.name} #{track.album.title} #{track.album.released}"
end

namespace :data do
  task default: [:reassociate, :cleanup_artists]

  task reassociate: :environment do
    before = Songsheet.where(track_id: nil).count
    updated = []

    Searchkick.callbacks(false) do
      Songsheet.find_each do |s|
        track_was = s.track
        AssociateSongsheetMetadata.perform_now(s)
        if track_was != s.track
          updated << s
          puts [track_info(track_was), track_info(s.track)].join(" ====> ")
        end
      end
    end

    after = Songsheet.where(track_id: nil).count
    puts "Associated #{before - after} songsheets to tracks"
    updated.each(&:reindex)
  end

  task cleanup_artists: :environment do
    before = Artist.count
    Artist.where(verified: false).find_each do |a|
      if a.songsheets.blank?
        puts "Deleting: #{a.name}"
        a.destroy
      end
    end
    after = Artist.count
    puts "Removed #{before - after}"
  end

  task extract_media: :environment do
    Searchkick.disable_callbacks
    youtube_url = /(https?:\/\/(?:www\.)?youtu(?:\.be|be\.com)[^\s}]*)/

    Songsheet.where("source ILIKE ?", "%youtu%").find_each do |songsheet|
      songsheet.perform_metadata_lookup = false

      songsheet.source = songsheet.source.lines.map do |line|
        if line =~ /^#{youtube_url.source}$/ || line =~ /{online_version:\s*#{youtube_url.source}}/
          line = "{meta: media #{$1}}\n"
          songsheet.metadata["media"] = [songsheet.metadata["media"], $1].flatten.compact
        elsif line.match?(youtube_url)
          puts ChordBook::CLIENT_URI + "songsheets/#{songsheet.id}"
        end
        line
      end.join("")

      songsheet.save
    end
  end

  task duplicate_artists: :environment do
    PaperTrail.enabled = false

    Artist
      .select("dups.*")
      .from("(SELECT *, ROW_NUMBER() OVER(PARTITION BY metadata->>'idArtist' ORDER BY created_at ASC) AS row FROM artists WHERE verified = true) dups")
      .where("dups.row > ?", 1).each do |artist|
      puts "Removing #{artist.name}"
      artist.destroy
    end
  end
end

task data: "data:default"
