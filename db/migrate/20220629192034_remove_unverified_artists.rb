class RemoveUnverifiedArtists < ActiveRecord::Migration[7.0]
  def change
    # FIXME: remove after running in production
    Artist.where(verified: false).destroy_all
    remove_column :artists, :verified
  end
end
