class Api::GenresController < ApiController
  def index
    @genres = Genre.order_by_popular.page(params[:page])
    set_pagination_header @genres
    fresh_when @genres
  end

  def show
    @genre = Genre.find(params[:id])
    fresh_when @genre
  end
end
