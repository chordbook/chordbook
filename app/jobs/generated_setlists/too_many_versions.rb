class GeneratedSetlists::TooManyVersions < GeneratedSetlists
  def perform
    update_setlist "Too Many Versions" do
      Songsheet.joins(:track).order("tracks.songsheets_count DESC, songsheets.rank")
    end
  end
end
