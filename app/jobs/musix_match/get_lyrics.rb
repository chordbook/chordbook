class MusixMatch::GetLyrics < ApplicationJob
  queue_as :low

  def perform(reference)
    response = MusixMatch.track_lyrics(reference.identifier)
    reference.update!(data: response["message"]["body"]["lyrics"])
  end
end
