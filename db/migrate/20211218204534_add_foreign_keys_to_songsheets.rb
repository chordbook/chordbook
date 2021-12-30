class AddForeignKeysToSongsheets < ActiveRecord::Migration[7.0]
  def change
    create_table :artist_works do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :work, polymorphic: true, null: false
      t.integer :order
      t.index [:artist_id, :work_id, :work_type, :order], unique: true, name: "uniq_by_artist_and_work"
    end

    change_table :songsheets do |t|
      t.references :track, null: true, foreign_key: true
    end
  end
end
