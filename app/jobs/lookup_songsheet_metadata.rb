class LookupSongsheetMetadata < ApplicationJob
  def perform(songsheet)
    Array(songsheet.metadata["artist"]).each do |name|
      unless Artist.find_by(name: name)
        LookupMetadata.perform_now(Artist.new(name: name), recursive: true)
      end
    end
  end
end
