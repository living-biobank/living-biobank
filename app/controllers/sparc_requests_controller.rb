class SparcRequestsController < ApplicationController

  def index
    @all_sparc_requests = current_user.sparc_requests
    @sparc_requests = @all_sparc_requests.active
  end

  def new
    @sparc_request = current_user.sparc_requests.new
  end

  def create
    @sparc_request = current_user.sparc_requests.new sparc_request_params
    @has_i2b2 = true

    if @sparc_request.valid?
      @sparc_request.status = 'Pending'
      @sparc_request.save
      flash.now[:success] = "Inquiry received, you should hear back from someone in 1-2 business days"
      redirect_to action: 'index'
    else
      flash.now[:error] = "Please complete all fields in order to proceed"
      render :new
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
    params.require(:sparc_request).permit(:short_title, :title, :description, :funding_status, :funding_source, :start_date, :end_date, :primary_pi_name, :query_name, :service_source, :service_id, :time_estimate, :status, :minimum_sample_size, :number_of_specimens_requested)
  end
end
