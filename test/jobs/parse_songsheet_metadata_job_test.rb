require "test_helper"

class ParseSongsheetMetadataJobTest < ActiveJob::TestCase
  test "updates metadata" do
    songsheet = create :songsheet, source: "{t: The Title}\n{key: C}"
    ParseSongsheetMetadataJob.new.perform(songsheet)
    assert_equal "The Title", songsheet.title
    assert_equal({"key" => "C"}, songsheet.metadata)
  end

  test "raises parse error" do
    songsheet = create :songsheet, source: "{t: malformed"
    assert_raises(NodeJob::Error) { ParseSongsheetMetadataJob.new.perform(songsheet) }
    assert_equal({}, songsheet.metadata)
  end
end
