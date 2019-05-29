class LabsController < ApplicationController
  before_action :verify_honest_broker

  def index
    @lab_groups = sort_lab_groups(Lab.available.search(params[:term]).includes(patient: :sparc_requests).group_by{ |l| { patient: l.patient, specimen_source: l.specimen_source } })

    @labs = Lab.joins(:patient)

    # @patients = labs.patient_id
    # @patients_mrn = @patients.patient.mrn

    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end

  def update
    @lab = Lab.find(params[:id])

    if params[:type] == "release"
      if @lab.update_attributes(status: "Released")
        redirect_to '/labs'
      end
    elsif params[:type] == "discard"
      if @lab.update_attributes(status: "Discarded")
        redirect_to '/labs'
      end
    elsif params[:type] == "retrieve"
      if @lab.update_attributes(status: "Retrieved")
        redirect_to '/labs'
      end
    end

  end

  private

  # NOTE:  sort_lab_groups may be deprecated in the future!
  def sort_lab_groups(lab_groups)
    groups = lab_groups.sort do |l, r|
      if params[:sort_by] == 'samples_available'
        l.last.count <=> r.last.count
      elsif params[:sort_by] == 'specimen_source'
        l.first[:specimen_source] <=> r.first[:specimen_source]
      else
        l.first[:patient].mrn <=> r.first[:patient].mrn
      end
    end

    groups = groups.reverse if params[:sort_order] == 'desc'

    groups
  end

  # def lab_params
  #   lab = params.permit(:lab_id)
  # end

end
