class Api::SongsheetsController < ApiController
  before_action :set_songsheet, only: %i[show update destroy]
  skip_before_action :authenticate!, only: %i[index show]

  # Use the updated_at timestamp of the parent association to determine freshness.
  # This ensures that reordering a setlist will invalidate the cache.
  etag { current_scope.proxy_association.owner.updated_at }

  # GET /songsheets.json
  def index
    @songsheets = current_scope.includes_track.page(params[:page])
    set_pagination_header @songsheets
    fresh_when @songsheets
  end

  # GET /songsheets/1.json
  def show
    track_view @songsheet
    fresh_when @songsheet
  end

  # POST /songsheets.json
  def create
    @songsheet = Songsheet.new(songsheet_params)

    if @songsheet.save
      current_user.library.add @songsheet
      render :show, status: :created, location: [:api, @songsheet]
    else
      render json: @songsheet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /songsheets/1.json
  def update
    if @songsheet.update(songsheet_params)
      render :show, status: :ok, location: [:api, @songsheet]
    else
      render json: @songsheet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /songsheets/1.json
  def destroy
    @songsheet.destroy
    head :no_content, location: api_songsheets_url
  end

  private

  def current_scope
    if params[:letter]
      super.starts_with(:title, params[:letter])
    else
      super.order_by_popular
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_songsheet
    @songsheet = Songsheet.find_by_uid(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def songsheet_params
    params.require(:songsheet).permit(:source, metadata: {})
  end
end
