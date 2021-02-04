class GroupsSourcesController < ApplicationController
  before_action :verify_admin
  before_action :find_group
  before_action :find_groups_source, only: [:edit, :update, :destroy]

  def index
    respond_to do |format|
      format.js
      format.json {
        @groups_sources = @group.groups_sources.active.filtered_for_index(params[:term], params[:sort_by], params[:sort_order]).paginate(page: params[:page].present? ? params[:page] : 1).eager_load(:source)
      }
    end
  end

  def new
    respond_to :js

    @groups_source  = @group.groups_sources.build
    @source         = @groups_source.build_source
  end

  def create
    respond_to :js

    @groups_source = @group.groups_sources.new(groups_source_params)

    # Invert the logic here using ! || ! soo we can run both sets
    # of validations. See the GroupsSource model about #unique_source?
    if !@groups_source.save || !@groups_source.unique_source?
      @errors = @groups_source.errors
    else
      flash.now[:success] = t('groups.sources.flash.created')
    end
  end

  def edit
    respond_to :js

    @source = @groups_source.source
  end

  def update
    respond_to :js

    if @groups_source.update_attributes(groups_source_params)
      flash.now[:success] = t('groups.sources.flash.updated')
    else
      @errors = @groups_source.errors
    end
  end

  def destroy
    respond_to :js

    @groups_source = GroupsSource.find(params[:id])

    if @groups_source.update(deprecated: true)
      flash.now[:success] = t('groups.sources.flash.destroyed')
    end
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_groups_source
    @groups_source = GroupsSource.find(params[:id])
  end

  def groups_source_params
    params.require(:groups_source).permit(
      :name,
      :description,
      :discard_age,
      source_attributes: [
        :id,
        :key,
        :value
      ]
    )
  end
end