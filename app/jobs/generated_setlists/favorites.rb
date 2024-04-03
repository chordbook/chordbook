class GeneratedSetlists::Favorites < GeneratedSetlists
  def perform
    update_setlist "All-time Favorites" do
      Songsheet.joins(:library_items).group(:id).order(Arel.sql("COUNT(*) DESC")).order_by_popular
    end
  end
end
