class GeneratedSetlists::WhatsNew < GeneratedSetlists
  def perform
    update_setlist "What's New" do
      # Get 300 most recently created, but limit to 100 sorted by rank to drop any
      # unranked or spammy stuff off the list.
      ids = Songsheet.order(created_at: :desc).limit(300).pluck(:id)
      Songsheet.where(id: ids).order_by_popular
    end
  end
end
