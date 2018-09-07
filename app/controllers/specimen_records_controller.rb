class SpecimenRecordsController < ApplicationController
  before_action :honest_broker_check

  def new
    @patient          = Patient.find(params[:patient_id])
    @specimen_record  = SpecimenRecord.new

    respond_to do |format|
      format.js
    end
  end

  def create
    sr                = Protocol.find(specimen_record_params[:protocol_id]).sparc_request
    @specimen_record  = SpecimenRecord.new(specimen_record_params.merge(
                          release_date: Date.today,
                          release_to: sr.primary_pi_netid,
                          service_id: sr.service_id,
                          service_source: sr.service_source
                        ))

    if @specimen_record.save
      flash.now[:success] = t(:specimen_records)[:created]
    else
      @errors = @specimen_record.errors
    end
  end

  private

  def specimen_record_params
    params[:specimen_record][:release_date] = sanitize_date(params[:specimen_record][:release_date])

    params.require(:specimen_record).permit(
      :protocol_id,
      :quantity,
      :mrn
    )
  end
end
