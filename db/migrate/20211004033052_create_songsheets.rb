class CreateSongsheets < ActiveRecord::Migration[6.1]
  def change
    create_table :songsheets do |t|
      t.text :body

      t.timestamps
    end
  end
end
