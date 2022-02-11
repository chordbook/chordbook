class Api::AlbumsController < ApiController

  def index
    @albums = current_scope.order_by_popular.page(params[:page])
    set_pagination_header @albums
  end

  def show
    @album = Album.find(params[:id])
  end
end
