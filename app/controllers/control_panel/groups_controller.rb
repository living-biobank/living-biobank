class ControlPanel::GroupsController < ApplicationController
  layout 'control_panel'

  def index
    respond_to :html, :js

    find_groups
  end

  def edit
    respond_to :js

    @group = Group.find(params[:id])
  end

  def update
    respond_to :js
  end

  private

  def find_groups
    @groups = current_user.groups.paginate(page: params[:page])
  end
end
