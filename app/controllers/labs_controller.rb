class LabsController < ApplicationController
  before_action :honest_broker_check

  def index
    respond_to do |format|
      format.html
      format.json {
        @labs = Lab.available.unreleased.includes(patient: :specimen_requests)
      }
    end
  end

  def update
    @lab = Lab.find(params[:id])
    @lab.update_attribute(:removed, true)
    respond_to do |format|
      format.js
    end
  end
end
