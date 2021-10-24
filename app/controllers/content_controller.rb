class ContentController < ActionController::Base
  def manifest
    render format: :json
  end

  def offline
    render format: :json
  end

  def tuner
    render layout: 'application'
  end
end
