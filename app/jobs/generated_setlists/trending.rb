class GeneratedSetlists::Trending < GeneratedSetlists
  def perform
    update_setlist "Trending" do
      Songsheet.order_by_popular
    end
  end
end
