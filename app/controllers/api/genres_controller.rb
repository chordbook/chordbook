class Api::GenresController < ApiController
  def index
    @genres = Genre.order_by_popular.page(params[:page])
    set_pagination_header @genres
  end

  def show
    @genre = Genre.find(params[:id])
  end
end
