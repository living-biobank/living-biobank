class PermissionsController < ControlPanelController

  def edit
    @user = User.find(params[:id])
    @groups = Group.all

    respond_to :js
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      current_user.reload  #necessary to check if current user is still an admin
      if current_user.admin
        flash.now[:success] = t(:control_panel)[:flash_messages][:save_successful]
      else
        flash[:error] = t(:control_panel)[:flash_messages][:self_admin_removed]
        ajax_redirect_to(sparc_requests_path)
      end
    else
      flash.now[:error] = @user.errors.full_messages.map(&:inspect).join(', ').delete! '"'
    end

    find_users

    respond_to :js
  end

  private
    def user_params
      params.require(:user).permit(
        :admin,
        :data_honest_broker,
        group_ids: []
      )
    end
end