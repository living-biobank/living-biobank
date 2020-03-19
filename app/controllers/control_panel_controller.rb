class ControlPanelController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.js
    end

    find_users
  end

  private

  def find_users
    @users = User.all
  end
end
