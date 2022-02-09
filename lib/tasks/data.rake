# FIXME: delete after running on production
namespace :data do
  task clean: [:ozbcoz, :reassociate, :update_tracks_with_songsheets, :update_genres]

  task ozbcoz: :environment do
    before_count = Songsheet.where(track_id: nil).count

    Songsheet.where(track_id: nil).where.not(imported_from: nil).find_each do |songsheet|
      songsheet.source = Import::Ozbcoz.new.lint(songsheet.source)
      chordpro = Chordpro.parse(songsheet.source)
      songsheet.metadata = chordpro.metadata.to_h
      songsheet.save

      if songsheet.track_id
        puts "Found: #{songsheet.title_was} => #{songsheet.title}"
      else
        puts "Not found: #{songsheet.title}"
      end
    end

    after_count = Songsheet.where(track_id: nil).count
    puts "Found: #{before_count - after_count}, #{after_count} to go"
  end

  task reassociate: :environment do
    # Update metadata associations in case data has changed
    Songsheet.find_each {|s| s.send(:associate_metadata); s.save }
  end

  task update_tracks_with_songsheets: :environment do
    Track.where(has_songsheet: true).find_each {|t| t.update has_songsheet: t.songsheets.length > 0 }
  end

  task update_genres: :environment do
    PopularGenres.perform_now
  end
end
