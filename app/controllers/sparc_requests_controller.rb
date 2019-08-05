class SparcRequestsController < ApplicationController

  before_action :find_request,  only: [:edit, :update, :destroy, :update_status]
  before_action :find_requests, only: [:index, :create, :update, :destroy, :update_status]

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @sparc_request = current_user.sparc_requests.new(status: t(:requests)[:statuses][:pending])
    @sparc_request.build_protocol(type: 'Project')
    @sparc_request.protocol.build_primary_pi_role
    @sparc_request.specimen_requests.build

    respond_to :js
  end

  def create
    @sparc_request = current_user.sparc_requests.new(sparc_request_params)

    if params[:save_draft]
      @sparc_request.status = t(:requests)[:statuses][:draft]
      @sparc_request.save(validate: false)

      flash.now[:success] = t(:requests)[:saved]
    elsif @sparc_request.save
      RequestMailer.with(user: current_user, request: @sparc_request).confirmation_email.deliver_later
      RequestMailer.with(user: current_user, request: @sparc_request).submission_email.deliver_later

      flash.now[:success] = t(:requests)[:created]
    else
      @errors = @sparc_request.errors
    end

    respond_to :js
  end

  def edit
    @sparc_request.status = t(:requests)[:statuses][:pending]

    respond_to :js
  end

  def update
    if params[:save_draft]
      @sparc_request.assign_attributes(sparc_request_params)
      @sparc_request.save(validate: false)

      flash.now[:success] = t(:requests)[:saved]
    elsif @sparc_request.update_attributes(sparc_request_params)
      flash.now[:success] = t(:requests)[:updated]
    else
      @errors = @sparc_request.errors
    end

    respond_to :js
  end

  def destroy
    @sparc_request.destroy

    respond_to :js
  end

  def update_status
    if @sparc_request.update_attribute(:status, sparc_request_params[:status])
      RequestMailer.with(user: current_user, request: @sparc_request).completion_email.deliver_later if @sparc_request.completed?

      flash.now[:success] = t(:requests)[:updated]
    else
      flash.now[:error] = t(:requests)[:failed]
    end

    respond_to :js
  end

  private

  def find_request
    @sparc_request = SparcRequest.find(params[:id])
  end

  def find_requests
    @requests       = (current_user.honest_broker.present? ? SparcRequest.all : current_user.sparc_requests).filtered_for_index(params[:term], params[:status], params[:sort_by], params[:sort_order])
    @draft_requests = current_user.honest_broker.present? ? SparcRequest.draft : current_user.sparc_requests.draft
  end

  def sparc_request_params
    if params[:sparc_request][:protocol_attributes]
      params[:sparc_request][:protocol_attributes][:start_date] = sanitize_date(params[:sparc_request][:protocol_attributes][:start_date]) if params[:sparc_request][:protocol_attributes][:start_date]
      params[:sparc_request][:protocol_attributes][:end_date]   = sanitize_date(params[:sparc_request][:protocol_attributes][:end_date]) if params[:sparc_request][:protocol_attributes][:end_date]
    end

    params.require(:sparc_request).permit(
      :protocol_id,
      :status,
      protocol_attributes: [
        :id,
        :research_master_id,
        :type,
        :short_title,
        :title,
        :brief_description,
        :funding_status,
        :funding_source,
        :potential_funding_source,
        :start_date,
        :end_date,
        primary_pi_role_attributes: [
          :id,
          :identity_id
        ]
      ],
      specimen_requests_attributes: [
        :id,
        :service_id,
        :source_id,
        :query_name,
        :number_of_specimens_requested,
        :minimum_sample_size,
        :_destroy
      ]
    )
  end
end
