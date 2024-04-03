class GeneratedSetlists::Decades < GeneratedSetlists
  def perform
    (1940..2010).step(10).to_a.reverse_each do |year|
      decade = (year...year + 10)
      update_setlist "#{year}s" do
        Songsheet.joins(track: :album).where("albums.released" => decade).order_by_popular
      end
    end
  end
end
