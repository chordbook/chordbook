class DropMedia < ActiveRecord::Migration[7.0]
  def change
    drop_table :media
  end
end
