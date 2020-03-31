class ControlPanel::UsersController < ControlPanel::BaseController
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
      if @user == current_user && @user.admin?
        flash.now[:success] = t('control_panel.users.flash.saved')
        find_users
      else
        flash.now[:error] = t('control_panel.users.flash.admin_removed')
        ajax_redirect_to(root_path)
      end
    else
      flash.now[:error] = @user.errors.full_messages.map(&:inspect).join(', ').delete! '"'
    end
  end

  private

  def find_users
    @users = User.all.paginate(page: params[:page]).eager_load(:groups)
  end

  def user_params
    params.require(:user).permit(
      :admin,
      :data_honest_broker,
      group_ids: []
    )
  end
end
