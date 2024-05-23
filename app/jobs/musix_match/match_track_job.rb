class MusixMatch::MatchTrackJob < ApplicationJob
  queue_as :low

  def perform(track)
    response = MusixMatch.match_track(q_artist: track.artist.name, q_track: track.title, q_album: track.album.title)
    data = response["message"]["body"]["track"]
    reference = track.references.find_or_initialize_by(source: :musixmatch, identifier: data["track_id"])
    reference.update! data: data
    MusixMatch::GetLyrics.perform_later(reference)
  end
end
