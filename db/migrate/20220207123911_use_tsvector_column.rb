class UseTsvectorColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :pg_search_documents, :content_tsv, :tsvector
    add_index :pg_search_documents, :content_tsv, using: "gin"
    add_index :pg_search_documents, :content, using: :gin, opclass: {title: :gin_trgm_ops}

    reversible do |dir|
      dir.up do
        execute "UPDATE pg_search_documents SET content_tsv = to_tsvector('english', content)"
        execute <<-SQL
          CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
          ON pg_search_documents FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(content_tsv, 'pg_catalog.english', content);
        SQL
      end
      dir.down do
        execute "DROP TRIGGER tsvectorupdate ON pg_search_documents"
      end
    end
  end
end
