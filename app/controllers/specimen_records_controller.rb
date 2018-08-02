class SpecimenRecordsController < ApplicationController
  before_action :honest_broker_check

  def new
    @lab = Lab.find(params[:lab_id])
    @specimen_record = @lab.specimen_records.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @specimen_record = SpecimenRecord.new(specimen_record_params)

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
      :lab_id,
      :protocol_id,
      :release_date,
      :release_to
    )
  end
end
