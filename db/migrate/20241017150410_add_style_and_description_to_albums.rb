class AddStyleAndDescriptionToAlbums < ActiveRecord::Migration[7.1]
  def change
    change_table :albums do |t|
      t.string :style
      t.text :description
    end
  end
end
