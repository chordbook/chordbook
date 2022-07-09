class GeneratedSetlists < ApplicationJob
  SETLISTS = {
    "Trending" => -> {
      Songsheet.order_by_popular.limit(100)
    },
    "What's New" => -> {
      Songsheet.where(created_at: 3.months.ago..).order_by_popular.limit(100)
    },
    "Recently Updated" => -> {
      Songsheet.where(updated_at: 2.months.ago..).order_by_popular.limit(100)
    },
    "All-time Favorites" => -> {
      Songsheet.joins(:library_items).group(:id).order(Arel.sql("COUNT(*) DESC")).limit(100)
    }
  }

  def perform
    SETLISTS.each do |title, scope|
      Setlist.transaction do
        setlist = User.app.owned_setlists.find_or_create_by!(title: title)
        setlist.items.clear
        setlist.songsheets = scope.call
      end
    end
  end
end
