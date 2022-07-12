class GeneratedSetlists < ApplicationJob
  def perform
    update_setlist "Trending" do
      Songsheet.order_by_popular
    end
    update_setlist "What's New" do
      Songsheet.where(created_at: 3.months.ago..).order_by_popular
    end
    update_setlist "Recently Updated" do
      Songsheet.where(updated_at: 2.months.ago..).order_by_popular
    end
    update_setlist "All-time Favorites" do
      Songsheet.joins(:library_items).group(:id).order(Arel.sql("COUNT(*) DESC")).order_by_popular
    end

    (1940..2010).step(10).to_a.reverse_each do |year|
      decade = (year...year + 10)
      update_setlist "#{year}s" do
        Songsheet.joins(track: :album).where("albums.released" => decade).order_by_popular
      end
    end

    update_setlist "TODO" do
      Songsheet.where(track_id: nil).order_by_recent
    end
  end

  def update_setlist(title, attrs: nil, &scope)
    Setlist.transaction do
      setlist = User.app.owned_setlists.find_or_create_by!(title: title) do |s|
        s.assign_attributes attrs if attrs
      end
      setlist.items.clear
      setlist.songsheets = scope.call.limit(100)
    end
  end
end
