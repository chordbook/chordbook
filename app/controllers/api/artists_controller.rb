class Api::ArtistsController < ApiController
  skip_before_action :authenticate!

  def index
    @artists = current_scope.with_attachments.order_by_alphabetical.page(params[:page])
    set_pagination_header @artists
    fresh_when @artists
  end

  def show
    @artist = Artist.with_attachments.find_by_uid(params[:id])
    fresh_when @artist
  end

  private

  def current_scope
    params[:letter] ? super.starts_with(:name, params[:letter]) : super
  end
end
