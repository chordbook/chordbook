class AddWeightToPgSearchDocuments < ActiveRecord::Migration[7.0]
  def change
    change_table :pg_search_documents do |t|
      t.float :weight, default: 1.0
    end
  end
end
