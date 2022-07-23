class Api::TracksController < ApiController
  skip_before_action :authenticate!

  def index
    @tracks = current_scope.order_by_popular.includes(:genre, :artist, album: :artist).page(params[:page])
    set_pagination_header @tracks
    fresh_when @tracks.to_a
  end

  def show
    @track = Track.find_by_uid(params[:id])
    fresh_when @track
  end
end
