class StoreQueriedFields < ActiveRecord::Migration[7.0]
  def change
    change_table :songsheets do |t|
      t.string :title
    end

    change_table :artists do |t|
      t.string :genre
      t.string :style
    end

    change_table :albums do |t|
      t.integer :released
      t.decimal :score, precision: 3, scale: 1
    end

    change_table :tracks do |t|
      t.integer :number
      t.integer :duration
      t.bigint :listeners
    end
  end
end
