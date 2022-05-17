class PopularGenres < ApplicationJob
  def perform
    Genre.find_each do |genre|
      genre.update(
        thumbnail: genre.example_artist&.thumbnail,
        listeners: genre.tracks.with_songsheet.sum(:listeners) || 0
      )
    end
  end
end
