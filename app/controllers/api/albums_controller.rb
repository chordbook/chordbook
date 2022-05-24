class Api::AlbumsController < ApiController
  skip_before_action :authenticate!

  def index
    @albums = current_scope.order_by_popular.page(params[:page])
    set_pagination_header @albums
    fresh_when @albums
  end

  def show
    @album = Album.find(params[:id])
    fresh_when @album
  end
end
