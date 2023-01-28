class Api::AuthenticateController < ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :access_denied
  skip_before_action :authenticate!, :current_token, except: :destroy

  def create
    @user = User.authenticate!(params[:email], params[:password])
    ahoy.authenticate @user
    issue_token @user
    render @user
  end

  def update
    @access_token = refresh_token!
    ahoy.authenticate @access_token.user
    render @access_token.user
  end

  def destroy
    current_token!.invalidate!
    head :ok
  end
end
