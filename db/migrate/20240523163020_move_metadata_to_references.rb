class MoveMetadataToReferences < ActiveRecord::Migration[7.1]
  def up
    {
      Artist => "idArtist",
      Album => "idAlbum",
      Track => "idTrack"
    }.each do |model, identifier|
      model.find_in_batches do |records|
        Reference.insert_all records.map { |record|
          {
            record_id: record.id,
            record_type: record.class.name,
            source: :theaudiodb,
            identifier: record.metadata[identifier],
            data: record.metadata
          }
        }
      end
    end
  end

  def down
    Reference.where(source: :theaudiodb).delete_all
  end
end
