class Api::SearchController < ApiController
  def index
    @results = PgSearch.multisearch(params[:q]).with_pg_search_rank.page(params[:page])
    unless params[:type].blank?
      @results = @results.where(searchable_type: params[:type].split(",").map { |type| type.singularize.titleize })
    end
    set_pagination_header @results
  end
end
