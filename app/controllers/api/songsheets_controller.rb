class Api::SongsheetsController < ApiController
  before_action :set_songsheet, only: %i[show update destroy]

  # GET /songsheets.json
  def index
    @songsheets = if params[:letter]
      current_scope.starts_with(:title, params[:letter])
    else
      current_scope.recent
    end
  end

  # GET /songsheets/1.json
  def show
  end

  # POST /songsheets.json
  def create
    @songsheet = Songsheet.new(songsheet_params)

    if @songsheet.save
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

  # Use callbacks to share common setup or constraints between actions.
  def set_songsheet
    @songsheet = Songsheet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def songsheet_params
    params.require(:songsheet).permit(:source, metadata: {})
  end
end
