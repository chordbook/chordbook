class Api::TracksController < ApiController
  def index
    @tracks = current_scope.order_by_popular.page(params[:page])
  end

  def show
    @track = Track.find(params[:id])
  end
end
