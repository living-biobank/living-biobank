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
        Lab.all
      else
        current_user.honest_broker_labs
      end.filtered_for_index(params[:term], params[:released_at_start], params[:released_at_end], params[:status], params[:source], params[:sort_by], params[:sort_order]).paginate(page: params[:page].present? ? params[:page] : 1).eager_load(:releaser, :patient, source: :groups_sources)
  end

  def lab_params
    params.require(:lab).permit(
      :line_item_id,
      :status,
      :released_at,
      :released_by,
      :retrieved_at,
      :discarded_at,
      :discarded_by,
      :discard_reason
    )
  end
end
