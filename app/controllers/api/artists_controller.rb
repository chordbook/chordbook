class Api::ArtistsController < ApiController
  before_action :set_artist, only: %i[show]

  def index
    @artists = params[:letter] ? Artist.starts_with(:name, params[:letter]) : Artist.all
  end

  def show
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end
end
