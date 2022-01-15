class Api::GenresController < ApiController
  def index
    @genres = Genre.order_by_popular.all
  end

  def show
    @genre = Genre.find(params[:id])
  end
end
