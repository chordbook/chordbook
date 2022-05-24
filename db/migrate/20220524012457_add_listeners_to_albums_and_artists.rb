class AddListenersToAlbumsAndArtists < ActiveRecord::Migration[7.0]
  def change
    add_column :artists, :listeners, :bigint
    add_column :albums, :listeners, :bigint
  end
end
