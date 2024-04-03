class GeneratedSetlists::Unmatched < GeneratedSetlists
  def perform
    update_setlist "Unmatched" do
      Songsheet.where(track_id: nil).order_by_recent
    end
  end
end
