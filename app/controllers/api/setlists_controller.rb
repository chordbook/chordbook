class Api::SetlistsController < ApiController
  before_action :authenticate!, except: %i[show]

  def index
    @setlists = current_user.setlists.order_by_recent.page(params[:page])
    set_pagination_header @setlists
    fresh_when @setlists
  end

  def show
    @setlist = Setlist.find(params[:id])
    fresh_when @setlist
  end

  def create
    @setlist = current_user.owned_setlists.build(setlist_params)
    @setlist.save!
    render :show
  end

  def destroy
    current_user.owned_setlists.find(params[:id]).destroy
    head :ok
  end

  private

  def setlist_params
    params.require(:setlist).permit(:title, :description)
  end
end
