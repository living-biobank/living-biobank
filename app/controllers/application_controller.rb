class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  layout :layout_by_resource

  before_action :authenticate_user!
  before_action :preload_settings

  def layout_by_resource
    if devise_controller?
      'home'
    else
      'application'
    end
  end

  def preload_settings
    SPARC::Setting.preload_values
  end

  def verify_honest_broker
    redirect_to root_path unless current_user.honest_broker.present?
  end

  def sanitize_date(date)
    Date.strptime(date, "%m/%d/%Y") rescue date
  end
end
