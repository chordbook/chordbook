class AddRank < ActiveRecord::Migration[7.0]
  def change
    add_column :songsheets, :rank, :bigint
    add_column :tracks, :rank, :bigint
    add_column :albums, :rank, :bigint
    add_column :artists, :rank, :bigint
    add_column :setlists, :rank, :bigint
    add_column :genres, :rank, :bigint
  end
end
