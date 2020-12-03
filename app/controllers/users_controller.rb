class UsersController < ApplicationController
  before_action :verify_admin

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
      flash.now[:error] = t('users.flash.admin_removed')
      ajax_redirect_to(root_path)
    else
      flash.now[:success] = t('users.flash.saved')
      find_users
    end
  end

  def search
    respond_to :js

    results = User.search(params[:term]).map{ |u| {
      label: u.display_name, id: u.id
    }}

    render json: results.to_json
  end

  private

  def find_users
    @users = User.all.filtered_for_index(params[:term], params[:privileges], params[:groups], params[:sort], params[:order]).paginate(page: params[:page].present? ? params[:page] : 1).preload(:groups)
  end

  def user_params
    params.require(:user).permit(
      :admin,
      :data_honest_broker,
      group_ids: []
    )
  end
end
