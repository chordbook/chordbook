class Api::SetlistsController < ApiController
  skip_before_action :authenticate!, only: %i[show]

  def index
    @setlists = current_user.setlists.includes(:user).with_attached_thumbnails.order_by_recent.page(params[:page])
    set_pagination_header @setlists
    fresh_when @setlists
  end

  def show
    @setlist = Setlist.includes(:user).with_attached_thumbnails.find_by_uid(params[:id])
    track_view @setlist
    fresh_when @setlist
  end

  def create
    @setlist = current_user.owned_setlists.build(setlist_params)
    @setlist.save!
    track_view @setlist
    render :show
  end

  def destroy
    current_user.owned_setlists.find_by_uid(params[:id]).destroy
    head :ok
  end

  private

  def setlist_params
    params.require(:setlist).permit(:title, :description)
  end
end
