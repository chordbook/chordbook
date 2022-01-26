class AddHasSongsheetToTracks < ActiveRecord::Migration[7.0]
  def change
    change_table :tracks do |t|
      t.boolean :has_songsheet
    end
  end
end
