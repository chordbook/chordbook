class Api::SearchController < ApiController
  def index
    @results = PgSearch.multisearch(params[:q]).page(params[:page]).without_count
    unless params[:type].blank?
      @results = @results.where(searchable_type: params[:type].split(",").map { |type| type.singularize.titleize })
    end
    set_pagination_header @results
    fresh_when @results
  end
end
