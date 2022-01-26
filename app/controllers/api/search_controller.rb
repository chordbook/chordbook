class Api::SearchController < ApiController
  def index
    @results = PgSearch.multisearch(params[:q]).limit(10).with_pg_search_rank
    unless params[:type].blank?
      @results = @results.where(searchable_type: params[:type].split(",").map { |type| type.singularize.titleize })
    end
  end
end
