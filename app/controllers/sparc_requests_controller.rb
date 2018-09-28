class SparcRequestsController < ApplicationController

  def index
    @requests = current_user.sparc_requests.active

    respond_to do |format|
      format.html
    end
  end

  def new
    @sparc_request = current_user.sparc_requests.new
  end

  def create
    @sparc_request = current_user.sparc_requests.new(sparc_request_params)

    if params[:save_draft]
      @sparc_request.status = 'Draft'
      @sparc_request.save(validate: false)
    elsif @sparc_request.save
      flash.now[:success] = t(:requests)[:created]
    else
      @errors = @sparc_request.errors
    end
  end

  def edit
    @sparc_request = current_user.sparc_requests.find(params[:id])
  end

  def update
    @sparc_request = current_user.sparc_requests.find(params[:id])

    if @sparc_request.update_attributes(sparc_request_params)
      flash.now[:success] = t(:requests)[:updated]
    else
      @errors = @sparc_request.errors
    end
  end

  def update_status
    @sparc_request = current_user.sparc_requests.find(params[:sparc_request_id])

    if @sparc_request.update_attribute(:status, sparc_request_params[:status])
      flash.now[:success] = t(:requests)[:updated]
    else
      flash.now[:error] = t(:requests)[:failed]
    end
  end

  private

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
      :primary_pi_email,
      :service_id,
      :service_source,
      :number_of_specimens_requested,
      :minimum_sample_size,
      :query_name,
      :status
    )
  end
end
