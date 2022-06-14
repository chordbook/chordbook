class Api::AuthenticateController < ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :access_denied
  skip_before_action :authenticate!, except: :destroy

  def create
    @user = User.authenticate!(params[:email], params[:password])
    issue_token @user
    render @user
  end

  def update
    @access_token = refresh_token!
    render @access_token.user
  end

  def destroy
    current_token!.invalidate!
    head :ok
  end
end
