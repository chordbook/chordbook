class Api::AuthenticateController < ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :access_denied
  skip_before_action :authenticate!, :current_token, except: :destroy

  def create
    @user = User.authenticate!(params[:email], params[:password])
    ahoy.authenticate @user
    issue_token @user
    render :show
  rescue ActiveRecord::RecordNotFound
    render json: {error: {message: "Invalid email or password"}}, status: :unauthorized
  end

  def update
    @access_token = refresh_token!
    @user = @access_token.user
    ahoy.authenticate @user
    render :show
  end

  def destroy
    current_token!.invalidate!
    head :ok
  end
end
