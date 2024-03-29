class ApplicationController < ActionController::Base
  require 'csv'
  protect_from_forgery prepend: true

  layout :layout_by_resource

  before_action :authenticate_user!
  before_action :preload_settings
  before_action :set_current_user
  around_action :handle_internal_server_error, if: Proc.new{ request.format.js? }

  private

  def layout_by_resource
    if devise_controller?
      'home'
    elsif errors_controller?
      'error'
    else
      'application'
    end
  end

  def preload_settings
    SPARC::Setting.preload_values
  end

  def verify_honest_broker
    redirect_to root_path unless current_user.admin? || current_user.lab_honest_broker?
  end

  def verify_admin
    redirect_to root_path unless current_user.admin?
  end

  def sanitize_date(date)
    Date.strptime(date, "%m/%d/%Y") rescue date
  end

  def errors_controller?
    helpers.errors_controller?
  end

  def ajax_redirect_to(url)
    render js: "window.location.assign('#{url}')"
  end

  def set_current_user
    User.current = current_user
  end

  def handle_internal_server_error
    ActiveRecord::Base.transaction do
      begin
        yield
      rescue => e
        if Rails.env.production?
          ExceptionNotifier.notify_exception(e)
        else
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.join("\n")
        end
        redirect_to controller: :errors, action: :internal_error
        raise ActiveRecord::Rollback
      end
    end
  end
end
