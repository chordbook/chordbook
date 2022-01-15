class CreateGenres < ActiveRecord::Migration[7.0]
  class Genre < ApplicationRecord; end

  class Artist < ApplicationRecord; end

  class Track < ApplicationRecord; end

  def change
    create_table :genres do |t|
      t.string :name
      t.timestamps
    end

    change_table :artists do |t|
      t.references :genre, foreign_key: true
    end

    change_table :tracks do |t|
      t.references :genre, foreign_key: true
    end

    reversible do |dir|
      dir.up do
        Artist.distinct.pluck(:genre).each do |name|
          unless name.blank?
            genre = Genre.find_or_create_by!(name: name)
            Artist.where(genre: name).update_all(genre_id: genre.id)
          end
        end

        Track.distinct.pluck(Arel.sql("metadata->>'strGenre'")).each do |name|
          unless name.blank?
            genre = Genre.find_or_create_by!(name: name)
            Track.where("metadata->>'strGenre' = ?", name).update_all(genre_id: genre.id)
          end
        end
      end
    end

    remove_column :artists, :genre
    add_index :tracks, [:genre_id, :listeners]
  end
end
