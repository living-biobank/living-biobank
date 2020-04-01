class ControlPanel::GroupsController < ControlPanel::BaseController
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

    @group = Group.find(params[:id])

    if @group.update_attributes(group_params)
      flash.now[:success] = t('control_panel.groups.flash.saved')

      find_groups
    else
      @errors = @group.errors
    end
  end

  private

  def find_groups
    @groups = Group.all.paginate(page: params[:page]).preload(:sources, services: :sparc_service, variables: :service)
  end

  def group_params
    params.require(:group).permit(
      :name,
      :notify_when_all_specimens_released,
      :release_email
    )
  end
end
