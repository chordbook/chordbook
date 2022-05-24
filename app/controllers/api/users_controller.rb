class Api::UsersController < ApiController
  def create
    @user = User.new(user_params)
    if @user.save
      issue_token @user
      render @user, status: :created
    else
      render_error record: @user
    end
  end

  def destroy
    current_user!.destroy
    head :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
