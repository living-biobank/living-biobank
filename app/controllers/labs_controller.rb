class LabsController < ApplicationController
  before_action :verify_honest_broker

  def index
    @labs = Lab.where(specimen_source: current_user.honest_broker.sources.pluck(:key)).includes(:patient, :populations, :line_item)

    @group_options = current_user.honest_broker

    respond_to do |format|
      format.html
    end
  end

  def update
    @lab = Lab.find(params[:id])

    if params[:type] == "release"
      line_item = LineItem.find(params[:line_item_id])
      request = line_item.sparc_request
      @primary_pi = line_item.sparc_request.primary_pi

      if @lab.update_attributes(status: I18n.t(:labs)[:statuses][:released], released_at: Time.now, line_item_id: line_item.id, recipient_id: @primary_pi.id)
        ReleaseSpecimenMailer.release_email(@primary_pi, request).deliver_later

        redirect_to action: :index
      end
    elsif params[:type] == "discard"
      if @lab.update_attributes(status: I18n.t(:labs)[:statuses][:discarded], discarded_at: Time.now)
        redirect_to action: :index
      end
    elsif params[:type] == "retrieve"
      if @lab.update_attributes(status: I18n.t(:labs)[:statuses][:retrieved], retrieved_at: Time.now)
        redirect_to action: :index
      end
    end

    respond_to do |format|
      format.js
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


end
