class ApplicationController < ActionController::Base
  private

  def info_for_paper_trail
    {ip: request.remote_ip, user_agent: request.user_agent}
  end
end
