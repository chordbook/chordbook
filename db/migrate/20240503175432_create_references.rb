class CreateReferences < ActiveRecord::Migration[7.1]
  def change
    create_table :references, id: :uuid do |t|
      t.references :record, polymorphic: true, null: false, type: :uuid
      t.string :identifier
      t.string :source
      t.json :data

      t.timestamps

      t.index [:record_type, :record_id, :source], unique: true
    end
  end
end
