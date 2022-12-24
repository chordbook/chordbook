class Api::HomeController < ApiController
  skip_before_action :authenticate!

  def show
    @setlists = User.app.setlists.order_by_popular.limit(13).to_a
    @featured_setlist = @setlists.shift

    @sections = [
      current_user && {
        name: "Jump Back In",
        items: current_user.recently_played.limit(12),
        format: "item"
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
