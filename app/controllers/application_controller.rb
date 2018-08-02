class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :authenticate_user!

  def honest_broker_check
    redirect_to root_path unless current_user.honest_broker?
  end

  def sanitize_date(date)
    Date.strptime(date, "%m/%d/%Y") rescue date
  end
end
