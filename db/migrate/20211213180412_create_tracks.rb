class CreateTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks do |t|
      t.string :title
      t.json :metadata
      t.references :artist, :album
      t.timestamps
    end
  end
end
