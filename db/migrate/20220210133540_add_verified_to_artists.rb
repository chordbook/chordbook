class AddVerifiedToArtists < ActiveRecord::Migration[7.0]
  def change
    add_column :artists, :verified, :boolean, default: false
    execute "UPDATE artists SET verified = (metadata->>'idArtist' IS NOT NULL)"
  end
end
