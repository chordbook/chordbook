class Api::SearchController < ApiController
  def index
    @results = PgSearch.multisearch(params[:q]).limit(10)
    unless params[:type].blank?
      @results = @results.where(searchable_type: params[:type].split(",").map { |type| type.singularize.titleize })
    end
  end
end
