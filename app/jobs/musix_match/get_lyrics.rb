class MusixMatch::GetLyrics < ApplicationJob
  queue_as :low

  def perform(reference)
    return unless Flipper.enabled?(:musixmatch)

    response = MusixMatch.track_lyrics(reference.identifier)
    reference.update!(data: response["message"]["body"]["lyrics"])
  end
end
