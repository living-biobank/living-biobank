class LabsController < ApplicationController
  before_action :verify_honest_broker

  def index
    @labs = Lab.joins(:patient).includes(:populations, :line_item)

    respond_to do |format|
      format.html
    end
  end

  def update
    @lab = Lab.find(params[:id])

    if params[:type] == "release"
      if @lab.update_attributes(status: I18n.t(:labs)[:statuses][:released], released_at: Time.now, line_item_id: params[:line_item], recipient_id: params[:recipient])
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
