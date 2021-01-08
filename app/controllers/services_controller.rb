class ServicesController < ApplicationController
  before_action :verify_admin
  before_action :find_group, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :find_service, only: [:edit, :update]

  def index
    respond_to do |format|
      format.js
      format.json {
        @services = @group.services.filtered_for_index(params[:term], params[:status], params[:condition], params[:sort_by], params[:sort_order]).paginate(page: params[:page].present? ? params[:page] : 1).preload(organization: { parent: { parent: :parent }})
      }
    end
  end

  def new
    respond_to :js

    @service = @group.services.build
  end

  def create
    respond_to :js

    @service = @group.services.new(services_params)

    if @service.save
      flash.now[:success] = t('groups.services.flash.created')
    else
      @errors = @service.errors
    end
  end

  def edit
    respond_to :js
  end

  def update
    respond_to :js

    if @service.update(services_params)
      flash.now[:success] = t('groups.services.flash.updated')
    else
      @errors = @service.errors
    end
  end

  def search
    term    = params[:term].strip
    results = SPARC::Service.search(term).
                eager_load(organization: { parent: { parent: :parent } }).
                sort_by{ |s| s.organization_hierarchy(true, false, false, true).map{ |o| [o.order, o.abbreviation] }.flatten }

    results.map! { |s|
      {
        id:             s.id,
        name:           s.display_service_name,
        description:    s.description,
        breadcrumb:     helpers.service_org_hierarchy(s),
        abbreviation:   s.abbreviation,
        cpt_code_text:  helpers.service_cpt_code(s),
        term:           term
      }
    }

    render json: results.to_json
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
      :condition,
      :position,
      :sparc_id,
      :status
    )
  end
end