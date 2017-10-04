class LabsController < ApplicationController
  before_action :authenticate_user!

  def index
    @labs = Lab.unreleased_labs.includes(patient: :specimen_requests)
  end
end
