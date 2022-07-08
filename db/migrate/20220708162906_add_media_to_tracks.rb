class AddMediaToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :media, :json
  end
end
