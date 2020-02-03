class LabsController < ApplicationController
  before_action :verify_honest_broker

  def index
    @labs =
      if current_user.admin?
        Lab.all.usable.order(status: :desc)
      else
        current_user.honest_broker.labs.usable.retrievable(current_user).order(status: :desc)
      end.includes(:source, :patient, line_item: { sparc_request: [:primary_pi, :protocol] })

    respond_to :html
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

    respond_to :js
  end
end
