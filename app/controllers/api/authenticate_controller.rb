class Api::AuthenticateController < ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :access_denied

  def create
    @user = User.authenticate!(params[:email], params[:password])
    issue_token(@user)
    head :created
  end
end
