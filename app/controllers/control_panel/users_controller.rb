class ControlPanel::UsersController < ApplicationController
  layout 'control_panel'

  def index
    respond_to :html, :js

    find_users
  end

  def edit
    respond_to :js

    @user = User.find(params[:id])
  end

  def update
    respond_to :js

    @user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      flash.now[:success] = t(:control_panel)[:flash_messages][:save_successful]
    else
      flash.now[:error] = @user.errors.full_messages.map(&:inspect).join(', ').delete! '"'
    end

    find_users
  end

  private

  def find_users
    @users = User.all.paginate(page: params[:page])
  end

  def user_params
    params.require(:user).permit(
      :admin,
      :data_honest_broker,
      group_ids: []
    )
  end
end
