class SpecimenRecordsController < ApplicationController
  before_action :honest_broker_check

  before_action :find_patient

  def new
    @specimen_record = SpecimenRecord.new

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
      @lab_groups = Lab.available.includes(patient: :specimen_requests).group_by{ |l| { patient: l.patient, specimen_source: l.specimen_source } }

      Delayed::Job.enqueue CloverleafMessengerJob.new(@patient.labs.available.first)

      flash.now[:success] = t(:specimen_records)[:created]
    else
      @errors = @specimen_record.errors
    end
  end

  private

  def find_patient
    @patint = Patient.find(params[:patient_id])
  end

  def specimen_record_params
    params[:specimen_record][:release_date] = sanitize_date(params[:specimen_record][:release_date])

    params.require(:specimen_record).permit(
      :protocol_id,
      :quantity,
      :mrn
    )
  end
end
