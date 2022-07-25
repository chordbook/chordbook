class ContentController < ActionController::Base
  def ping
    # Execute empty query to ensure database access
    ActiveRecord::Base.connection.execute("")
    Searchkick.client.ping

    head :ok
  end
end
