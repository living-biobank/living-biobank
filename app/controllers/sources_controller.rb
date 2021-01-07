class SourcesController < ApplicationController
  before_action :verify_admin
  before_action :find_group

  def index
    respond_to :js, :json

    # @sources = @group.sources.active.filtered_for_index(params[:term], nil, nil, params[:sort], params[:order]).paginate(page: params[:page].present? ? params[:page] : 1)

    @sources = @group.groups_sources.active
  end

  def new
    respond_to :js

    @source = @group.sources.build
  end

  def edit
    respond_to :js
    find_groups_source

    @source = @groups_source.source
  end

  def update
    respond_to :js

    @groups_source = @group.groups_sources.where(source: params[:id]).first

    @source = @groups_source.source
    if @source.update(sources_params.except(:group_id, :name))
      #update join table association on success
      @group.groups_sources.where(source: @source).first.update(name: params[:name], description: params[:description])
      flash.now[:success] = t('groups.sources.flash.updated')
    else
      @errors = @source.errors
    end
  end

  def create
    respond_to :js

    #Checks for key uniqueness within the specified group
    unless @group.sources.any? {|source| source.key == sources_params[:key]}
      #If key is unique, begins process of adding new source
      @source = Source.new(sources_params.except(:group_id, :name, :description))
      if @source.save
        #create join table association on success
        @group.groups_sources.create!(source: @source, name: params[:name], description: params[:description])
        flash.now[:success] = t('groups.sources.flash.created')
      else
        @errors = @source.errors
      end
    else
      #If key is not unique, throws error
      @group.errors.add(:key, t('groups.sources.errors.key_exists'))
      @errors = @group.errors
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

  def sources_params
    params.require(:source).permit(
      :group_id,
      :name,
      :key,
      :value,
      :description
    )
  end
end