class Api::HistoryController < ApiController
  skip_before_action :authenticate!

  # GET /history.json
  def show
    @songsheets = Songsheet.viewed_by(current_user).includes_track.page(params[:page])
    set_pagination_header @songsheets
    fresh_when @songsheets
  end
end
