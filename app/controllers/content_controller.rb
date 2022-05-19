class ContentController < ActionController::Base
  def ping
    # Execute empty query to ensure database access
    ActiveRecord::Base.connection.execute("")

    head :ok
  end
end
