class Api::TracksController < ApiController
  def index
    @tracks = current_scope.order_by_popular.limit(12)
  end

  def show
    @track = Track.find(params[:id])
  end
end
