class SparcRequestsController < ApplicationController
  before_action :find_request,  only: [:show, :edit, :update, :destroy, :update_status]
  before_action :find_requests, only: [:index]

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def new
    @sparc_request = current_user.sparc_requests.new(status: t(:requests)[:statuses][:pending])
    @sparc_request.build_protocol(type: 'Study', selected_for_epic: false)
    @sparc_request.protocol.build_primary_pi_role
    @sparc_request.protocol.build_research_types_info
    @sparc_request.specimen_requests.build

    respond_to :js
  end

  def create
    @sparc_request = current_user.sparc_requests.new(sparc_request_params)

    if params[:save_draft]
      @sparc_request.status = t(:requests)[:statuses][:draft]
      @sparc_request.save(validate: false)

      flash.now[:success] = t(:requests)[:saved]
    else
      if @sparc_request.save
        RequestMailer.with(user: current_user, request: @sparc_request).confirmation_email.deliver_later
        RequestMailer.with(requester: current_user, request: @sparc_request).submission_email.deliver_later

        flash.now[:success] = t(:requests)[:created]
      else
        @errors = @sparc_request.errors
      end
    end

    find_requests

    respond_to :js
  end

  def edit
    @is_draft             = @sparc_request.draft?
    @sparc_request.status = t(:requests)[:statuses][:pending]

    if @sparc_request.specimen_requests.none?
      @sparc_request.specimen_requests.build
    end

    respond_to :js
  end

  def update
    if params[:save_draft]
      @sparc_request.assign_attributes(sparc_request_params)
      @sparc_request.save(validate: false)

      flash.now[:success] = t(:requests)[:saved]
    else
      if @sparc_request.update_attributes(sparc_request_params)
        flash.now[:success] = t(:requests)[:updated]
      else
        @errors = @sparc_request.errors
      end
    end

    find_requests

    respond_to :js
  end

  def update_status
    @sparc_request.assign_attributes(sparc_request_params)

    # Ignore validations, specifically for Draft requests
    if @sparc_request.save(validate: false)
      RequestMailer.with(completer: current_user, request: @sparc_request).completion_email.deliver_later if @sparc_request.completed?

      flash.now[:success] = t(:requests)[:updated]
    else
      flash.now[:error] = t(:requests)[:failed]
    end

    find_requests

    respond_to :js
  end

  private

  def find_request
    @sparc_request = SparcRequest.find(params[:id])
  end

  def find_requests
    @requests =
      if current_user.admin? || current_user.data_honest_broker?
        SparcRequest.all
      elsif current_user.lab_honest_broker?
        current_user.sparc_requests.merge(current_user.honest_broker_requests)
      else
        current_user.sparc_requests
      end.filtered_for_index(params[:term], params[:status], params[:sort_by], params[:sort_order]).paginate(page: params[:page].present? ? params[:page] : 1).eager_load(:requester, specimen_requests: [:labs, :source, :group]).preload(:protocol, :primary_pi, additional_services: [:service, :sub_service_request])

    @draft_requests = current_user.sparc_requests.draft.preload(:protocol)
  end

  def sparc_request_params
    if params[:sparc_request][:protocol_attributes]
      params[:sparc_request][:protocol_attributes][:start_date] = sanitize_date(params[:sparc_request][:protocol_attributes][:start_date]) if params[:sparc_request][:protocol_attributes][:start_date]
      params[:sparc_request][:protocol_attributes][:end_date]   = sanitize_date(params[:sparc_request][:protocol_attributes][:end_date]) if params[:sparc_request][:protocol_attributes][:end_date]

      # Prvent the user from creating multiple new protocols by setting the Protocol ID on subsequent submits
      if (rmid = params[:sparc_request][:protocol_attributes][:research_master_id]) && !params[:sparc_request][:protocol_id] && (protocol = SPARC::Protocol.find_by(research_master_id: rmid))
        params[:sparc_request][:protocol_id]              = protocol.id
        params[:sparc_request][:protocol_attributes][:id] = protocol.id
      end
    end

    params.require(:sparc_request).permit(
      :id,
      :protocol_id,
      :status,
      :finalized_at,
      :finalized_by,
      :completed_by,
      :cancelled_by,
      protocol_attributes: [
        :id,
        :research_master_id,
        :type,
        :selected_for_epic,
        :short_title,
        :title,
        :brief_description,
        :funding_status,
        :funding_source,
        :potential_funding_source,
        :start_date,
        :end_date,
        :sponsor_name,
        primary_pi_role_attributes: [
          :id,
          :identity_id
        ],
        research_types_info_attributes: [
          :id
        ]
      ],
      specimen_requests_attributes: [
        :id,
        :source_id,
        :query_name,
        :number_of_specimens_requested,
        :minimum_sample_size,
        :_destroy
      ]
    )
  end
end
