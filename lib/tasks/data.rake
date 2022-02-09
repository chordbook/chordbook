namespace :data do
  task default: [:reassociate, :tracks, :genres]

  task reassociate: :environment do
    # Update metadata associations in case data has changed
    Songsheet.find_each do |s|
      s.send(:associate_metadata)
      s.save
    end
  end

  task tracks: :environment do
    Track.where(has_songsheet: true).find_each { |t| t.update has_songsheet: t.songsheets.length > 0 }
  end

  task genres: :environment do
    PopularGenres.perform_now
  end
end
