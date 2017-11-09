class SpecimenRecordsController < ApplicationController
  before_action :honest_broker_check

  def new
    @specimen_record = SpecimenRecord.new
    @protocol_ids = params[:protocol_ids].split(':')
    respond_to do |format|
      format.js
    end
  end

  def create
    @specimen_record = SpecimenRecord.new(specimen_record_params)

    sr = SparcRequest.find_by_protocol_id specimen_record_params[:protocol_id]
    @specimen_record.release_date = Date.today
    @specimen_record.release_to = sr.primary_pi_netid
    @specimen_record.service_id = sr.service_id
    @specimen_record.service_source = sr.service_source

    respond_to do |format|
      if @specimen_record.save
        format.js
      end
    end
  end

  private

  def specimen_record_params
    params.require(:specimen_record).permit(
      :protocol_id,
      :quantity
    )
  end
end
