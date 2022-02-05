class Api::ArtistsController < ApiController
  before_action :set_artist, only: %i[show]

  def index
    @artists = current_scope.order("UPPER(name)").page(params[:page])
    set_pagination_header @artists
  end

  def show
  end

  private

  def current_scope
    params[:letter] ? Artist.starts_with(:name, params[:letter]) : Artist.all
  end

  def set_artist
    @artist = Artist.find(params[:id])
  end
end
