class ControlPanelController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.js
    end

    find_users
  end

  def edit_user
    @user = User.find(params[:id])
    @groups = Group.all

    respond_to :js
  end

  def update_user
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      flash.now[:success] = t(:control_panel)[:flash_messages][:save_successful]
    else
      flash.now[:error] = @user.errors.full_messages.map(&:inspect).join(', ').delete! '"'
    end

    find_users

    respond_to :js
  end

  private
    def find_users
      @users = User.all
    end

    def user_params
      params.require(:user).permit(
        :admin,
        :data_honest_broker,
        group_ids: []
      )
  end
end
