class AddTitleToSongsheet < ActiveRecord::Migration[6.1]
  def change
    add_column :songsheets, :title, :string
    add_column :songsheets, :subtitle, :string
  end
end
