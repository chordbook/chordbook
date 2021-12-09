class RenameSongsheetsToSongs < ActiveRecord::Migration[6.1]
  def change
    rename_table :songsheets, :songs
  end
end
