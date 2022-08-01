class Api::DiscoverController < ApiController
  skip_before_action :authenticate!

  def show
    @setlists = User.app.setlists.with_attachments.order_by_popular.limit(12)
  end
end
