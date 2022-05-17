class Api::SetlistsController < ApiController
  before_action :find_setlist, only: [:show, :destroy]

  def index
    @setlists = current_scope.order_by_recent.page(params[:page])
    set_pagination_header @setlists
    fresh_when @setlists
  end

  def show
    fresh_when @setlist
  end

  def create
    @setlist = Setlist.new(setlist_params)
    @setlist.save!
    render :show
  end

  def destroy
    @setlist.destroy
    head :ok
  end

  private

  def setlist_params
    params.require(:setlist).permit(:title, :description)
  end

  def find_setlist
    @setlist = Setlist.find(params[:id])
  end
end
