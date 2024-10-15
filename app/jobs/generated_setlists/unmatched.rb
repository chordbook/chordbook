class GeneratedSetlists::Unmatched < GeneratedSetlists
  EXCLUDED = [
    "Traditional"
  ]

  def perform
    update_setlist "Unmatched" do
      Songsheet.where(track_id: nil).where("metadata->>'subtitle' NOT IN (?)", EXCLUDED).order_by_recent
    end
  end
end
