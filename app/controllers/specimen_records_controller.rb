class SpecimenRecordsController < ApplicationController

  def new
    @specimen_record = SpecimenRecord.new
    @lab = Lab.find(params[:lab_id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @specimen_record = SpecimenRecord.new(specimen_record_params)
    @specimen_record.release_date = DateTime.strptime(
      specimen_record_params[:release_date], '%m/%d/%Y'
    ).to_date
    respond_to do |format|
      if @specimen_record.save
        @labs = Lab.unreleased_labs.includes(patient: :specimen_requests)
        format.js
      end
    end
  end

  private

  def specimen_record_params
    params.require(:specimen_record).permit(
      :lab_id,
      :protocol_id,
      :release_date,
      :release_to
    )
  end
end
