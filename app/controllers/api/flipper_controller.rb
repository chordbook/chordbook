class Api::FlipperController < ApiController
  skip_before_action :authenticate!

  def show
    render json: {
      enabled: Flipper.enabled?(params[:feature], current_user)
    }
  end
end
