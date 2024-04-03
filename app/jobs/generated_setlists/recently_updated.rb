class GeneratedSetlists::RecentlyUpdated < GeneratedSetlists
  def perform
    update_setlist "Recently Updated" do
      # Get 300 most recently updated, but limit to 100 sorted by rank to drop any
      # unranked or spammy stuff off the list.
      ids = Songsheet.order(updated_at: :desc).limit(300).pluck(:id)
      Songsheet.where(id: ids).order_by_popular
    end
  end
end
