class Api::TracksController < ApiController
  def index
    @tracks = current_scope.order_by_popular.page(params[:page])
    set_pagination_header @tracks
  end

  def show
    @track = Track.find(params[:id])
  end
end
