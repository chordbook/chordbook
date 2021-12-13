class Api::TracksController < ApplicationController
  before_action :set_parent

  def index
    @tracks = @parent.tracks.limit(100)
  end

  private

  def set_parent
    @parent = params[:album_id] ? Album.find(params[:album_id]) : Artist.find(params[:artist_id])
  end
end
