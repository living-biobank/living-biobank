class LabsController < ApplicationController
  before_action :authenticate_user!, :find_labs

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
      .unreleased_labs
      .includes(patient: :specimen_requests)
  end
end
