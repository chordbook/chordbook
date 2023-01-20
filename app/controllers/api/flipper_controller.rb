class Api::FlipperController < ApiController
  skip_before_action :authenticate!

  def show
    features = Flipper.features.map do |feature|
      [feature.key, Flipper.enabled?(feature.key, current_user)]
    end

    render json: features.to_h
  end
end
