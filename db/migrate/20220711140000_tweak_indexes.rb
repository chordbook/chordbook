class TweakIndexes < ActiveRecord::Migration[7.0]
  def change
    remove_index :artist_works, :artist_id, name: "index_artist_works_on_artist_id"
    add_index :tracks, [:genre_id, :rank]
  end
end
