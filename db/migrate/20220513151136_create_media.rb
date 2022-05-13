class CreateMedia < ActiveRecord::Migration[7.0]
  def change
    create_table :media do |t|
      t.references :record, polymorphic: true
      t.string :uri
      t.timestamps
    end
  end
end
