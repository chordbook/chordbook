class Api::AlbumsController < ApiController
  before_action :set_artist

  def index
    @albums = @artist.albums.all
  end

  private

  def set_artist
    @artist = Artist.find(params[:artist_id])
  end

end
