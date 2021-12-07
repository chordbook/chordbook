class ContentController < ActionController::Base
  def offline
    render format: :json
  end

  def tuner
    render layout: "application"
  end
end
