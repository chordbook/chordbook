class GeneratedSetlists < ApplicationJob
  def perform
    update_setlist "Trending", Songsheet.order_by_popular
    update_setlist "What's New", Songsheet.where(created_at: 3.months.ago..).order_by_popular
    update_setlist "Recently Updated", Songsheet.where(updated_at: 2.months.ago..).order_by_popular
    update_setlist "All-time Favorites", Songsheet.joins(:library_items).group(:id).order(Arel.sql("COUNT(*) DESC")).order_by_popular

    (1940..2010).step(10).to_a.reverse do |year|
      decade = (year...year + 10)
      update_setlist "#{decade}s", Songsheet.joins(track: :album).where("albums.released" => decade).order_by_popular
    end
  end

  def update_setlist(title, scope, attrs: nil)
    Setlist.transaction do
      setlist = User.app.owned_setlists.find_or_create_by!(title: title) do |s|
        s.assign_attributes attrs if attrs
      end
      setlist.items.clear
      setlist.songsheets = scope.limit(100)
    end
  end
end
