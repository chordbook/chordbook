class CreateAlbums < ActiveRecord::Migration[6.1]
  def change
    create_table :albums do |t|
      t.string :title
      t.json :metadata
      t.references :artist

      t.timestamps
    end
  end
end
