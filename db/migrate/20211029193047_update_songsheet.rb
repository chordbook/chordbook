class UpdateSongsheet < ActiveRecord::Migration[6.1]
  def change
    change_table :songsheets do |t|
      t.remove :title, :subtitle, type: :string
      t.rename :body, :source
    end
  end
end
