class SongsheetsController < ApplicationController
  before_action :set_songsheet, only: %i[ show edit update destroy ]

  # GET /songsheets or /songsheets.json
  def index
    @songsheets = Songsheet.all
  end

  # GET /songsheets/1 or /songsheets/1.json
  def show
  end

  # GET /songsheets/new
  def new
    @songsheet = Songsheet.new
  end

  # GET /songsheets/1/edit
  def edit
  end

  # POST /songsheets or /songsheets.json
  def create
    @songsheet = Songsheet.new(songsheet_params)

    respond_to do |format|
      if @songsheet.save
        format.html { redirect_to @songsheet, notice: "Songsheet was successfully created." }
        format.json { render :show, status: :created, location: @songsheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @songsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songsheets/1 or /songsheets/1.json
  def update
    respond_to do |format|
      if @songsheet.update(songsheet_params)
        format.html { redirect_to @songsheet, notice: "Songsheet was successfully updated." }
        format.json { render :show, status: :ok, location: @songsheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @songsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songsheets/1 or /songsheets/1.json
  def destroy
    @songsheet.destroy
    respond_to do |format|
      format.html { redirect_to songsheets_url, notice: "Songsheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_songsheet
      @songsheet = Songsheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def songsheet_params
      params.require(:songsheet).permit(:body)
    end
end
