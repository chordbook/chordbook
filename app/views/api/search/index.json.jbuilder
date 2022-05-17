json.array! @results do |result|
  json.merge! id: result.id, type: result.class
  case result
  when Songsheet
    json.merge!(
      title: result.title,
      subtitle: Array(result.metadata["artist"]).to_sentence,
      thumbnail: result.track&.album&.thumbnail
    )
  when Artist
    json.merge!(
      title: result.name,
      thumbnail: result.thumbnail
    )
  when Album
    json.merge!(
      title: result.title,
      subtitle: result.artist.name,
      thumbnail: result.thumbnail
    )
  when Track
    json.merge!(
      title: result.title,
      subtitle: result.artist.name,
      thumbnail: result.album&.thumbnail
    )
  end
end
