class RemoveGenreThumbnail < ActiveRecord::Migration[7.0]
  def change
    remove_column :genres, :thumbnail
  end
end
