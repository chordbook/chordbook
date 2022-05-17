class ContentController < ActionController::Base
  def index
    render file: Rails.root.join("public/index.html")
  end

  def offline
    render format: :json
  end

  def ping
    # Execute empty query to ensure database access
    ActiveRecord::Base.connection.execute("")

    head :ok
  end
end
