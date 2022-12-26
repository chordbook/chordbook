class Api::HomeController < ApiController
  skip_before_action :authenticate!

  def show
    @featured_setlist = User.app.setlists.order_by_popular.first
    @setlists = User.app.setlists.order_by_popular.offset(1)

    @sections = [
      Section.new(
        name: "Keep on playing",
        scope: Songsheet.viewed_by(current_user),
        format: "item"
      ),
      Section.new(
        name: current_user ? "Your favorite setlists" : "Popular setlists",
        scopes: [
          Setlist.viewed_by(current_user),
          current_user&.setlists&.order_by_recent,
          @setlists
        ].compact,
        format: "card"
      ),
      Section.new(
        name: @featured_setlist.title,
        scope: @featured_setlist.songsheets,
        format: "item",
        href: api_setlist_path(@featured_setlist)
      ),
      Section.new(
        name: "Get to know the artists",
        scopes: [
          Artist.viewed_by(current_user),
          Artist.order_by_popular
        ],
        format: "card"
      )
    ].select { |section| section.items.size > 3 }
  end
end
