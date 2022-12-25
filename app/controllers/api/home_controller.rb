class Api::HomeController < ApiController
  skip_before_action :authenticate!

  def show
    @setlists = User.app.setlists.order_by_popular.limit(13).to_a
    @featured_setlist = @setlists.shift

    @sections = [
      current_user && {
        name: "Keep On Playing",
        description: "Songs you've played recently",
        items: current_user.recently_played.limit(12),
        format: "item"
      },
      current_user && {
        name: "Your Setlists",
        items: current_user.setlists.order_by_recent.limit(6),
        href: api_setlists_path,
        format: "card"
      },
      {
        name: @featured_setlist.title,
        items: @featured_setlist.songsheets.limit(24),
        href: api_setlist_path(@featured_setlist),
        format: "item"
      },
      {
        name: "Featured Setlists",
        items: @setlists,
        format: "card"
      }
    ].compact
  end
end
