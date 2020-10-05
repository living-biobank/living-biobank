class ControlPanel::SourcesController < ControlPanel::BaseController
  before_action :find_group

  def index
    respond_to :js, :json

    # @sources = @group.sources.active.filtered_for_index(params[:term], nil, nil, params[:sort], params[:order]).paginate(page: params[:page].present? ? params[:page] : 1)

    # @sources = @group.sources.active
  end

  def new
    respond_to :js

    @source = @group.sources.build
  end

  def edit
    respond_to :js

    @source = @group.sources.where(id: params[:id]).first
    @groups_source_name = @group.groups_sources.where(source: params[:id]).first.name
  end

  def update
    respond_to :js

    @groups_source = @group.groups_sources.where(source: params[:id]).first

    @source = @groups_source.source
    if @source.update(sources_params.except(:group_id, :name))
      #update join table association on success
      @group.groups_sources.where(source: @source).first.update(name: params[:name])
      flash.now[:success] = t('control_panel.groups.sources.flash.created')
    else
      @errors = @source.errors
    end
  end

  def create
    respond_to :js

    #Checks for key uniqueness within the specified group
    unless @group.sources.any? {|source| source.key == sources_params[:key]}
      #If key is unique, begins process of adding new source
      @source = @group.sources.build(sources_params.except(:group_id, :name))
      if @source.save
        #create join table association on success
        @group.groups_sources.create!(source: @source, name: params[:name])
        flash.now[:success] = t('control_panel.groups.sources.flash.created')
      else
        @errors = @source.errors
      end
    else
      #If key is not unique, throws error
      @group.errors.add(:key, t('control_panel.groups.sources.errors.key_exists'))
      @errors = @group.errors
    end
  end

  def destroy
    respond_to :js

    @source = Source.find(params[:id])

    if @source.groups_sources.where(source: @source).first.update(deprecated: true)
      flash.now[:success] = t('control_panel.groups.sources.flash.destroyed')
    end
  end

  private

  def find_group
    puts params[:group_id]
    @group = Group.find(params[:group_id])
  end

  def sources_params
    params.require(:source).permit(
      :group_id,
      :name,
      :key,
      :value
    )
  end
end