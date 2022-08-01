class Api::AlbumsController < ApiController
  skip_before_action :authenticate!

  def index
    @albums = current_scope.with_attachments.order_by_popular
      .joins(:artist).merge(Artist.with_attachments).page(params[:page])
    set_pagination_header @albums
    fresh_when @albums
  end

  def show
    @album = Album.with_attachments.joins(:artist, :tracks).merge(Artist.with_attachments).find_by_uid(params[:id])
    fresh_when @album
  end
end
