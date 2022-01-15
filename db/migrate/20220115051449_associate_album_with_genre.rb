class AssociateAlbumWithGenre < ActiveRecord::Migration[7.0]
  class Genre < ApplicationRecord; end

  class Album < ApplicationRecord; end

  def change
    change_table :albums do |t|
      t.references :genre, foreign_key: true
    end

    reversible do |dir|
      dir.up do
        Album.distinct.pluck(Arel.sql("metadata->>'strGenre'")).each do |name|
          unless name.blank?
            genre = Genre.find_or_create_by!(name: name)
            Album.where("metadata->>'strGenre' = ?", name).update_all(genre_id: genre.id)
          end
        end
      end
    end
  end
end
