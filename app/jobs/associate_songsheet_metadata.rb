class AssociateSongsheetMetadata < ApplicationJob
  def perform(songsheet)
    return if songsheet.metadata["artist"].blank?

    # Prevent jobs from being enqueued recursively
    songsheet.skip_metadata_lookup = true

    songsheet.artists = lookup_artists(songsheet.metadata["artist"])

    track = Track.where(artist_id: songsheet.artist_ids).lookup(songsheet.title)
    songsheet.track = track if track

    songsheet.save
  end

  def lookup_artists(value)
    (value.is_a?(Array) ? value : value.split(/\s*,\s*/)).map do |name|
      Artist.lookup(name) || Artist.new(name: name.strip)
    end
  end
end
