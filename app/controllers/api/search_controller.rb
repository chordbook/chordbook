class Api::SearchController < ApiController
  skip_before_action :authenticate!
  skip_before_action :track_ahoy_visit, only: :convert

  def index
    @search = Search.new(
      query: params[:q],
      load: false,
      models: models,
      page: params[:page],
      per_page: 25,
      track: {user_id: current_user&.id}
    )

    @results = @search.results
    attachment_ids = @results.map { |r| r[:attachment_id] }.compact
    @attachments = ActiveStorage::Attachment.includes(:record, blob: :variant_records).where(id: attachment_ids).index_by(&:id)
    set_pagination_header @results
    fresh_when @results
  end

  def convert
    @search = Searchjoy::Search.find(params[:search_id])
    @model = ShortIdentifier.locate(params[:id])
    @search.convert(@model)
    head :created
  end

  private

  def models
    params[:type].blank? ?
      Search::MODELS :
      Search::MODELS & params[:type].split(",").map { |type| type.singularize.classify.constantize }
  end
end
