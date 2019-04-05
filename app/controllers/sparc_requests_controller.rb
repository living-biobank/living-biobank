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
    @sparc_request = current_user.sparc_requests.new
    @sparc_request.line_items.build
  end

  def create
    @sparc_request = current_user.sparc_requests.new(sparc_request_params)

    if params[:save_draft]
      @sparc_request.status = t(:requests)[:statuses][:draft]
      @sparc_request.save(validate: false)

      flash.now[:success] = t(:requests)[:saved]
    elsif @sparc_request.save
      RequestMailer.with(user: current_user, request: @sparc_request).confirmation_email.deliver_later
      RequestMailer.with(request: @sparc_request).submission_email.deliver_later

      flash.now[:success] = t(:requests)[:created]
    else
      @errors = @sparc_request.errors
      @line_item_params = sparc_request_params[:line_items_attributes]
    end
  end

  def edit
  end

  def update
    if @sparc_request.update_attributes(sparc_request_params)
      flash.now[:success] = t(:requests)[:updated]

      RequestMailer.with(user: current_user, request: @sparc_request).completion_email.deliver_later if @sparc_request.completed?
    else
      @errors = @sparc_request.errors
      @line_item_params = sparc_request_params[:line_items_attributes]
    end
  end

  def destroy
    @sparc_request.destroy
  end

  def update_status
    if @sparc_request.update_attribute(:status, sparc_request_params[:status])
      flash.now[:success] = t(:requests)[:updated]
    else
      flash.now[:error] = t(:requests)[:failed]
    end
  end

  private

  def find_request
    @sparc_request = SparcRequest.find(params[:id])
  end

  def find_requests
    @requests       = (current_user.honest_broker? ? SparcRequest.all : current_user.sparc_requests).filtered_for_index(params[:term], params[:status], params[:sort_by], params[:sort_order])
    @draft_requests = current_user.honest_broker? ? SparcRequest.draft : current_user.sparc_requests.draft
  end

  def sparc_request_params
    params[:sparc_request][:start_date] = sanitize_date(params[:sparc_request][:start_date])
    params[:sparc_request][:end_date]   = sanitize_date(params[:sparc_request][:end_date])

    params.require(:sparc_request).permit(
      :short_title,
      :title,
      :description,
      :funding_status,
      :funding_source,
      :start_date,
      :end_date,
      :primary_pi_name,
      :primary_pi_netid,
      :primary_pi_email,
      :query_name,
      :status,
      line_items_attributes: [
        :service_id,
        :service_source,
        :number_of_specimens_requested,
        :minimum_sample_size,
        :_destroy
      ]
    )
  end
end
