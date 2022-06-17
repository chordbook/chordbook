class SitemapsController < ApplicationController
  caches_page :index, :show

  # Cache for the day
  self.page_cache_directory = -> {
    Rails.root.join("tmp/cache/page", Date.today.to_s)
  }

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
