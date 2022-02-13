class Api::SetlistsController < ApiController
  def index
    @setlists = current_scope.page(params[:page])
    set_pagination_header @setlists
  end

  def show
    @setlist = Setlist.find(params[:id])
  end
end
