class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  layout :layout_by_resource

  before_action :authenticate_user!

  def layout_by_resource
    if devise_controller?
      'home'
    else
      'application'
    end
  end

  def honest_broker_check
    redirect_to root_path unless current_user.honest_broker?
  end

  def sanitize_date(date)
    Date.strptime(date, "%m/%d/%Y") rescue date
  end
end
