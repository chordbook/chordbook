def track_info(track)
  return unless track

  "#{track.title} (#{track.listeners}) - by #{track.artist.name} #{track.album.title} #{track.album.released}"
end

namespace :data do
  task default: [:reassociate, :genres, :cleanup_artists]

  task reassociate: :environment do
    before = Songsheet.where(track_id: nil).count
    Songsheet.find_each do |s|
      track_was = s.track
      AssociateSongsheetMetadata.perform_now(s)
      if track_was != s.track
        puts [track_info(track_was), track_info(s.track)].join(" ====> ")
      end
    end
    after = Songsheet.where(track_id: nil).count

    puts "Associated #{before - after} songsheets to tracks"
  end

  task genres: :environment do
    PopularGenres.perform_now
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
    youtube_url = /(https?:\/\/(?:www\.)?youtu(?:\.be|be\.com)[^\s}]*)/

    Songsheet.where("source ILIKE ?", "%youtu%").find_each do |songsheet|
      songsheet.source.lines.select { |line| line =~ /youtu(be\.com|\.be)/ }.each do |line|
        if line =~ youtube_url
          songsheet.media.find_or_create_by(uri: $1)
        else
          puts "NOPE!: #{line}"
        end
      end
    end
  end
end

task data: "data:default"
