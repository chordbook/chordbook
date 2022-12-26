class Api::HomeController < ApiController
  skip_before_action :authenticate!

  def show
    @setlists = User.app.setlists.order_by_popular.limit(13).to_a
    @featured_setlist = @setlists.shift

    @sections = [
      {
        name: @featured_setlist.title,
        items: @featured_setlist.songsheets.limit(12),
        href: api_setlist_path(@featured_setlist),
        format: "item"
      },
      {
        name: "Featured Setlists",
        items: @setlists,
        format: "card"
      }
    ]

    if current_user
      @sections.unshift(
        {
          name: "Keep On Playing",
          description: "Songs you've played recently",
          items: current_user.recently_played.limit(12),
          format: "item"
        },
        {
          name: "Your Setlists",
          items: current_user.setlists.order_by_recent.limit(6),
          href: api_setlists_path,
          format: "card"
        }
      )
    end
  end
end
