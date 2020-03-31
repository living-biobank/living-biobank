class ControlPanelController < ApplicationController
  before_action :admin_check

  def index
    respond_to do |format|
      format.html
      format.js
    end

    find_users
  end

  private

  def admin_check
    unless current_user.admin
      flash[:error] = t(:control_panel)[:flash_messages][:access_denied]
      redirect_to controller: 'sparc_requests', action: 'index'
    end
  end

  def find_users
    @users = User.all
  end
end
