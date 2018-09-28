class LabsController < ApplicationController
  before_action :honest_broker_check

  def index
    @lab_groups = Lab.available.includes(patient: :specimen_requests).group_by{ |l| { patient: l.patient, specimen_source: l.specimen_source } }

    respond_to do |format|
      format.html
    end
  end
end
