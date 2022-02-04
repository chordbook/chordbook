class AddImportedFromToSongsheets < ActiveRecord::Migration[7.0]
  def change
    change_table :songsheets do |t|
      t.string :imported_from
    end
  end
end
