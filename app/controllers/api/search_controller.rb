class Api::SearchController < ApiController
  def index
    @results = Search.new(query: params[:q], models: models, page: params[:page], per_page: 25).results
    set_pagination_header @results
    fresh_when @results
  end

  def models
    params[:type].blank? ?
      Search::MODELS :
      Search::MODELS & params[:type].split(",").map { |type| type.singularize.classify.constantize }
  end
end
