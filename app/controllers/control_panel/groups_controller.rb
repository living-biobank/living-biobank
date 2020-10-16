class ControlPanel::GroupsController < ControlPanel::BaseController
  before_action :find_group, except: [:index, :new, :create]

  def index
    respond_to :html, :js, :json

    @groups = Group.all.filtered_for_index(params[:term], params[:sort], params[:order]).paginate(page: params[:page].present? ? params[:page] : 1).preload(:active_groups_sources, services: :sparc_service)
  end

  def new
    respond_to :html

    @group = Group.new
  end

  def create
    respond_to :js

    @group = Group.new(group_params)
    if @group.save
      flash.now[:success] = t('control_panel.groups.flash.created')
    else
      @errors = @group.errors
    end
  end

  def edit
    respond_to :html
  end

  def update
    respond_to :js

    @group = Group.find(params[:id])
    if @group.update_attributes(group_params)
      flash.now[:success] = t('control_panel.groups.flash.saved')
    else
      @errors = @group.errors
    end
  end

  private

  def find_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(
      :name,
      :process_sample_size,
      :process_specimen_retrieval,
      :notify_when_all_specimens_released,
      :release_email,
      :discard_email,
      :finalize_email,
      :finalize_email_subject,
      :finalize_email_to
    )
  end
end
