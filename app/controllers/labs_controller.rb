class LabsController < ApplicationController
  before_action :verify_honest_broker
  before_action :find_lab, only: :update
  before_action :find_labs, only: :index

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @lab.update_attributes(lab_params)

    find_labs

    respond_to :js
  end

  private

  def find_lab
    @lab = Lab.find(params[:id])
  end

  def find_labs
    @labs =
      if current_user.admin?
        Lab.all.order(status: :desc)
      else
        current_user.honest_broker.labs.retrievable(current_user).order(status: :desc)
      end.filtered_for_index(params[:term], params[:status], params[:source], params[:sort_by], params[:sort_order]).paginate(page: params[:page]).includes(:source, :patient, line_item: { sparc_request: [:primary_pi, :protocol] })
  end

  def lab_params
    params.require(:lab).permit(
      :line_item_id,
      :status
    )
  end
end
