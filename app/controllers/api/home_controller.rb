class Api::HomeController < ApiController
  skip_before_action :authenticate!

  def show
    @featured_setlist = User.app.setlists.with_attachments.order_by_popular.first

    @sections = [
      Section.new(
        name: "Keep on playing",
        scope: Songsheet.viewed_by(current_user).includes_track,
        format: "item"
      ),
      Section.new(
        name: current_user ? "Your favorite setlists" : "Popular setlists",
        scopes: [
          Setlist.viewed_by(current_user).with_attachments,
          current_user&.setlists&.order_by_recent&.with_attachments,
          User.app.setlists.with_attachments.order_by_popular.offset(1)
        ].compact,
        format: "card"
      ),
      Section.new(
        name: @featured_setlist.title,
        scope: @featured_setlist.songsheets.includes_track,
        format: "item",
        href: api_setlist_path(@featured_setlist)
      ),
      Section.new(
        name: "Get to know the artists",
        scopes: [
          Artist.with_attachments.viewed_by(current_user),
          Artist.with_attachments.order_by_popular
        ],
        format: "card"
      )
    ].select { |section| section.items.size > 3 }
  end
end
