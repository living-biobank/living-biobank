class ControlPanel::GroupsController < ControlPanel::BaseController
  def index
    respond_to :html, :js, :json

    find_groups
  end

  def edit
    respond_to :js

    find_group
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

  def find_group
    @group = Group.find(params[:id])
  end

  def find_groups
    @groups = Group.all.filtered_for_index(params[:term], params[:sort], params[:order]).paginate(page: params[:page].present? ? params[:page] : 1).preload(:sources, services: :sparc_service, variables: :service)
  end

  def group_params
    params.require(:group).permit(
      :name,
      :process_sample_size,
      :display_patient_information,
      :notify_when_all_specimens_released,
      :release_email,
      :discard_email,
      :finalize_email,
      :finalize_email_subject,
      :finalize_email_to
    )
  end
end
