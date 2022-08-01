class ApiController < ActionController::API
  include Authentication
  include ActionController::Helpers
  helper ApplicationHelper

  # Authenticate by default. Call `skip_before_action :authenticate!` on actions that don't need it
  before_action :authenticate!

  private

  # Return the current scope based on current controller and route
  #
  # For example, in the `Api::SongsheetsController`, a request to
  # `GET /artists/:artist_id/songsheets` will return
  # `Artist.find_by_uid(params[:artist_id]).songsheets`.
  #
  def current_scope
    @current_scope ||= %w[track album artist genre setlist].detect do |name|
      id = params["#{name}_id"]
      break name.classify.constantize.find_by_uid(id).send(default_scope_name) if id
    end || default_scope
  end

  def default_scope_name
    controller_name
  end

  # Default to authenticated user's library
  def default_scope
    current_user!.send(default_scope_name)
  end

  def set_pagination_header(scope, options = {})
    page = {}
    page[:next] = scope.current_page + 1 unless scope.last_page?
    page[:prev] = scope.current_page - 1 unless scope.first_page?

    links = page.map do |rel, page|
      url = url_for(request.params.merge(only_path: false, page: page))
      "<#{url}>; rel=\"#{rel}\""
    end
    headers["Link"] = links.join(", ")
  end

  def render_error(message = nil, record: nil, exception: nil, status: :unprocessable_entity)
    response = if record
      {error: record.errors}
    elsif message
      {error: {message: message}}
    end

    render json: response, status: status
  end
end
