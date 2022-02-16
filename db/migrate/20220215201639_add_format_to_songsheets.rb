class AddFormatToSongsheets < ActiveRecord::Migration[7.0]
  def change
    add_column :songsheets, :format, :string
    execute "UPDATE songsheets SET format = 'ChordPro'"
  end
end
