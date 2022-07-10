class Api::DiscoverController < ApiController
  skip_before_action :authenticate!

  def show
    @setlists = User.app.setlists.limit(12)
  end
end
