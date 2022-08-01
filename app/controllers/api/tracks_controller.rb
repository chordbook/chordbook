class Api::TracksController < ApiController
  skip_before_action :authenticate!

  def index
    @tracks = current_scope.order_by_popular.includes(:artist, album: :artist)
      .merge(Album.with_attachments).merge(Artist.with_attachments).page(params[:page])
    set_pagination_header @tracks
    fresh_when @tracks
  end

  def show
    @track = Track.find_by_uid(params[:id])
    fresh_when @track
  end
end
