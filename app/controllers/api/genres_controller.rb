class Api::GenresController < ApiController
  skip_before_action :authenticate!

  def index
    @genres = Genre.with_attachments.order_by_popular.page(params[:page])
    set_pagination_header @genres
    fresh_when @genres
  end

  def show
    @genre = Genre.find_by_uid(params[:id])
    fresh_when @genre
  end
end
