class CreateSetLists < ActiveRecord::Migration[7.0]
  def change
    create_table :setlists do |t|
      t.string :title
      t.text :description

      t.timestamps
    end

    create_table :setlist_items do |t|
      t.belongs_to :setlist, foreign_key: true
      t.belongs_to :songsheet, foreign_key: true
      t.bigint :position

      t.timestamps
    end
  end
end
