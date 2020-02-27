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

  def update_user
    @user = User.find(params[:id])

    @user.update_attributes(user_params)
  end

  private
    def user_params
      params.require(:user).permit(
        :admin,
        :honest_broker_id
      )
  end
end
