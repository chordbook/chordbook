class Api::TracksController < ApplicationController
  before_action :set_scope

  def index
    @tracks = @scope.order_by_popular.limit(36)
  end

  private

  def set_scope
    @scope ||= if params[:album_id]
      Album.find(params[:album_id]).tracks
    elsif params[:artist_id]
      Artist.find(params[:artist_id]).tracks
    else
      Track
    end
  end
end
