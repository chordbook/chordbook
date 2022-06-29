class AssociateSongsheetMetadata < ApplicationJob
  def perform(songsheet, lookup_unknown_artist: true)
    artist = songsheet.metadata["artist"] || songsheet.metadata["subtitle"]

    # No need to continue if no artists declared
    return if artist.blank?

    # Prevent jobs from being enqueued recursively
    songsheet.perform_metadata_lookup = false

    # Find all artists
    artists, unknown = Artist.lookup_all(artist)
    songsheet.artists = artists

    if lookup_unknown_artist
      unknown.each do |name|
        LookupMetadata.perform_later name, reassociate: songsheet
      end
    end

    # No need to continue if no artists found
    return if artists.blank?

    # Associate track
    track = Track.where(artist_id: songsheet.artist_ids).lookup(songsheet.title)
    songsheet.update track: track if track
  end
end
