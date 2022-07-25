# Look up YouTube videos for a track
class YoutubeLookup < ApplicationJob
  queue_as :metadata

  # Probably hit API limit, retry tomorrow
  retry_on Google::Apis::ClientError, wait: 24.hours

  API_KEY = ENV["YOUTUBE_API_KEY"]
  SERVICE = Google::Apis::YoutubeV3::YouTubeService.new.tap do |service|
    service.key = API_KEY
  end

  SEARCHES = [
    "How to play %{title} by %{artist}",
    "%{title} by %{artist}"
  ]

  def perform(track)
    # YouTube search quota is too low, avoid looking up again for now
    return if track.media.size > 0

    ids = SEARCHES.map do |query|
      result = SERVICE.list_searches(:snippet, q: query % {title: track.title, artist: track.artist.name}, type: "video")
      result.items[0].id.video_id
    end.compact

    track.update media: ids.map { |id| "https://www.youtube.com/watch?v=%s" % id }
  end

  def self.top_tracks
    Track.where(media: nil).order_by_popular.limit(50).each do |track|
      perform_later track
    end
  end
end
