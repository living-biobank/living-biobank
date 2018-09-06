class SparcRequestsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json {
        @sparc_requests = current_user.sparc_requests
      }
    end
  end

  def new
    @sparc_request = current_user.sparc_requests.new
  end

  def create
    @sparc_request = current_user.sparc_requests.new(sparc_request_params)

    if @sparc_request.save
      flash.now[:success] = t(:requests)[:created]
    else
      @errors = @sparc_request.errors
    end
  end

  def edit
    @sparc_request = current_user.sparc_requests.find params[:id]
  end

  def update
    @sparc_request = current_user.sparc_requests.find params[:id]
    @sparc_request.assign_attributes sparc_request_params

    if @sparc_request.save
      flash.now[:success] = "Inquiry updated"
      redirect_to action: 'index'
    else
      flash.now[:error] = "Please complete all fields in order to proceed"
      render :edit
    end
  end

  def update_status
    @sparc_request = current_user.sparc_requests.find params[:sparc_request_id]

    if @sparc_request.update_attributes status: params[:new_status]
      flash.now[:success] = "Inquiry updated"
    else
      flash.now[:error] = "Unabled to update the status of your inquiry"
    end

    redirect_to action: 'index'
  end

  private

  def sparc_request_params
    params[:sparc_request][:start_date] = sanitize_date(params[:sparc_request][:start_date])
    params[:sparc_request][:end_date]   = sanitize_date(params[:sparc_request][:end_date])

    params.require(:sparc_request).permit(
      :short_title,
      :title,
      :funding_status,
      :funding_source,
      :start_date,
      :end_date,
      :primary_pi_name,
      :query_name,
      :service_source,
      :service_id
    )
  end
end
