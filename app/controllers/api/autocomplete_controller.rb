class Api::AutocompleteController < ApiController
  skip_before_action :authenticate!

  def index
    case params[:type]
    when "title", "t"
      @results = Track.includes(:album, :artist).starts_with(:title, params[:query]).limit(10)
    when "artist"
      @results = Artist.starts_with(:name, params[:query]).limit(10)
    else
      render json: "Unknown type: #{params[:type].inspect}", status: :unprocessable_entity
    end
  end
end
