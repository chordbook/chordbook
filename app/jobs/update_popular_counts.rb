class UpdatePopularCounts < ApplicationJob
  def perform
    # These fields aren't currently indexed
    Searchkick.callbacks(false) do
      Artist.find_each do |artist|
        artist.update listeners: artist.tracks.with_songsheet.sum(:listeners) || 0
      end

      Album.find_each do |album|
        album.update listeners: album.tracks.with_songsheet.sum(:listeners) || 0
      end

      Genre.find_each do |genre|
        genre.update(
          thumbnail: genre.artists.first&.thumbnail,
          listeners: genre.tracks.sum(:listeners) || 0
        )
      end
    end
  end
end
