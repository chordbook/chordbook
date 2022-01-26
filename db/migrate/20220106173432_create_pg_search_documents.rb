class CreatePgSearchDocuments < ActiveRecord::Migration[7.0]
  def up
    say_with_time("Creating table for pg_search multisearch") do
      create_table :pg_search_documents do |t|
        t.text :content
        t.json :data
        t.belongs_to :searchable, polymorphic: true, index: true
        t.timestamps null: false
      end

      enable_extension :pg_trgm
      enable_extension :unaccent
    end
  end

  def down
    say_with_time("Dropping table for pg_search multisearch") do
      drop_table :pg_search_documents
      disable_extension :pg_trgm
    end
  end
end
