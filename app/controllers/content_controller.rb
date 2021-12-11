class ContentController < ActionController::Base
  def index
    render layout: "application"
  end

  def offline
    render format: :json
  end
end
