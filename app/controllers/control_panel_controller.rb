class ControlPanelController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.js
    end

    @users = User.all
  end

  def edit_user
    @user = User.find(params[:id])
    @groups = Group.all

    respond_to :js
  end

end
