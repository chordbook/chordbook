class Api::ArtistsController < ApiController
  before_action :set_artist, only: %i[show]

  def index
    @artists = current_scope.order_by_alphabetical.page(params[:page])
    set_pagination_header @artists
  end

  def show
  end

  private

  def current_scope
    params[:letter] ? super.starts_with(:name, params[:letter]) : super
  end

  def set_artist
    @artist = Artist.find(params[:id])
  end
end
