class ServicesController < ApplicationController
  before_action :verify_admin
  before_action :find_group

  def index
    respond_to :js, :json

  end

  def new
    respond_to :js

    @service = @group.services.build
  end

  def edit
    respond_to :js

    find_service
  end

  def update
    respond_to :js

    find_service

    if @service.update(services_params.except(:group_id))
      flash.now[:success] = t('groups.services.flash.updated')
    else
      @errors = @service.errors
    end
  end

  def create
    respond_to :js

    @service = @group.services.new(services_params.except(:group_id))

    if @service.save
      flash.now[:success] = t('groups.services.flash.created')
    else
      @errors = @service.errors
    end
  end

  def destroy
    respond_to :js

    find_service

    if @service.delete
      flash.now[:success] = t('groups.services.flash.destroyed')
    end
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_service
    @service = Service.find(params[:id])
  end

  def services_params
    params.require(:service).permit(
      :group_id,
      :sparc_id,
      :status,
      :position,
      :condition
    )
  end
end