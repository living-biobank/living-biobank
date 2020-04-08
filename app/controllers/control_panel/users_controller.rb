class ControlPanel::UsersController < ControlPanel::BaseController
  def index
    respond_to :html, :js, :json

    find_users
  end

  def edit
    respond_to :js

    @user = User.find(params[:id])
  end

  def update
    respond_to :js

    @user = User.find(params[:id])
    @user.update_attributes(user_params)

    if @user == current_user && !@user.admin?
      flash.now[:error] = t('control_panel.users.flash.admin_removed')
      ajax_redirect_to(root_path)
    else
      flash.now[:success] = t('control_panel.users.flash.saved')
      find_users
    end
  end

  private

  def find_users
    @users = User.all.filtered_for_index(params[:term], params[:privileges], params[:groups], params[:sort_by], params[:sort_order]).paginate(page: params[:page].present? ? params[:page] : 1).preload(:groups)
  end

  def user_params
    params.require(:user).permit(
      :admin,
      :data_honest_broker,
      group_ids: []
    )
  end
end
