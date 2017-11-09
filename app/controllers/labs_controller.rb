class LabsController < ApplicationController
  before_action :find_labs, :honest_broker_check

  def index
  end

  def update
    @lab = Lab.find(params[:id])
    @lab.update_attribute(:removed, true)
    respond_to do |format|
      format.js
    end
  end

  private

  def find_labs
    @labs = Lab.where(removed: false)
      .includes(patient: :specimen_requests)
      .group_by { |l| l.patient_id.to_s + l.specimen_source.to_s }
  end
end
