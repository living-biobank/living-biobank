class SparcRequestsController < ApplicationController

  def index
    @sparc_requests = current_user.sparc_requests
  end

  def new
    @sparc_request = current_user.sparc_requests.new
  end

  def create
    @sparc_request = current_user.sparc_requests.new sparc_request_params

    if @sparc_request.valid?
      @sparc_request.save
      flash.now[:success] = "Inquiry received, you should hear back from someone in 1-2 business days"
      render :index
    else
      flash.now[:error] = "Please complete all fields in order to proceed"
      render :new
    end
  end

  private
  def sparc_request_params
    params.require(:sparc_request).permit(:short_title, :title, :funding_status, :funding_source, :start_date, :end_date, :primary_pi_name, :query_name, :service_source, :service_id)
  end
end
