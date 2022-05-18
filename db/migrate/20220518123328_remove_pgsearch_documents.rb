class RemovePgsearchDocuments < ActiveRecord::Migration[7.0]
  def change
    drop_table :pg_search_documents
  end
end
