class ContentController < ActionController::Base
  def index
`    render file: Rails.root.join('public/index.html')
`  end

  def offline
    render format: :json
  end
end
