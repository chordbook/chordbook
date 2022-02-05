class StoreGenreFields < ActiveRecord::Migration[7.0]
  def change
    change_table :genres do |t|
      t.string :thumbnail
      t.bigint :listeners
    end
  end
end
