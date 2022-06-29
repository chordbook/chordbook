class AssociateSongsheetMetadata < ApplicationJob
  def perform(songsheet, lookup_unknown_artist: true)
    artist = songsheet.metadata["artist"] || songsheet.metadata["subtitle"]
    return if artist.blank?

    # Prevent jobs from being enqueued recursively
    songsheet.perform_metadata_lookup = false

    songsheet.artists = split_artists(artist).map do |name|
      Artist.lookup(name).tap do |artist|
        LookupMetadata.perform_later name, reassociate: songsheet if !artist && lookup_unknown_artist
      end
    end.compact

    track = Track.where(artist_id: songsheet.artist_ids).lookup(songsheet.title)
    songsheet.track = track if track

    songsheet.save
  end

  def split_artists(value)
    (value.is_a?(Array) ? value : value.split(/\s*,\s*/))
  end
end
