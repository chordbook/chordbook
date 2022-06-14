class CreateLibraryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :library_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, polymorphic: true

      t.timestamps
    end

    change_table :setlists do |t|
      t.references :user, foreign_key: true
    end
  end
end
