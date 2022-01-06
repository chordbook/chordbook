class ApiController < ActionController::API
  private

  # Return the current scope based on current controller and route
  #
  # For example, in the `Api::SongsheetsController`, a request to
  # `GET /api/artists/:artist_id/songsheets` will return
  # `Artist.find(params[:artist_id]).songsheets`.
  #
  def current_scope
    @current_scope ||= %w[track album artist].detect do |name|
      id = params["#{name}_id"]
      break name.classify.constantize.find(id).send(default_scope_name) if id
    end || default_scope
  end

  def default_scope_name
    controller_name
  end

  def default_scope
    controller_name.singularize.classify.constantize
  end
end
