class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def honest_broker_check
    redirect_to root_path unless current_user.honest_broker?
  end
end
