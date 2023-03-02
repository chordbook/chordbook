class ParseSongsheetMetadataJob < NodeJob
  self.script_path = Rails.root.join("app/jobs/parse_songsheet_metadata.mjs").to_s

  def perform(songsheet)
    songsheet.update! metadata: super(songsheet.source)
  end

  def self.all
    Songsheet.find_each do |songsheet|
      ParseSongsheetMetadataJob.perform_later(songsheet)
    end
  end
end
