class RenameSongsBackToSongsheets < ActiveRecord::Migration[6.1]
  def change
    rename_table :songs, :songsheets
  end
end
