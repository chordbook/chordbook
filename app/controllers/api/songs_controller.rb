class Api::SongsController < ApplicationController
  before_action :set_song, only: %i[show update destroy]

  # GET /songs.json
  def index
    @songs = Song.recent
  end

  # GET /songs/1.json
  def show
  end

  # POST /songs.json
  def create
    @song = Song.new(song_params)

    if @song.save
      render :show, status: :created, location: [:api, @song]
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /songs/1.json
  def update
    if @song.update(song_params)
      render :show, status: :ok, location: [:api, @song]
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # DELETE /songs/1.json
  def destroy
    @song.destroy
    head :no_content, location: api_songs_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @song = Song.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def song_params
    params.require(:song).permit(:source, metadata: {})
  end
end
