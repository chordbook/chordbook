class AddMetadataToSongsheets < ActiveRecord::Migration[6.1]
  def change
    change_table :songsheets do |t|
      t.json :metadata
    end
  end
end
