class SitemapsController < ApplicationController
  SITEMAPS = {
    genres: Genre,
    songsheets: Songsheet,
    artists: Artist,
    albums: Album,
    setlists: Setlist
  }.with_indifferent_access.freeze

  def index
    @sitemaps = SITEMAPS.keys
  end

  def show
    @records = SITEMAPS[params[:id]].select(:id, :updated_at)
  end
end
