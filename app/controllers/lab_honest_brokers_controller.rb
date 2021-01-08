class LabHonestBrokersController < ApplicationController
  before_action :verify_admin
  before_action :find_group

  def index
    respond_to do |format|
      format.js
      format.json {
        @honest_brokers = @group.lab_honest_brokers.filtered_for_index(params[:term], params[:sort], params[:order]).paginate(page: params[:page].present? ? params[:page] : 1)
      }
    end
  end

  def new
    respond_to :js

    @honest_broker = @group.lab_honest_brokers.new
  end

  def create
    respond_to :js

    @honest_broker = @group.lab_honest_brokers.new(lab_honest_broker_params)

    if @honest_broker.save
      flash.now[:success] = t('groups.lab_honest_brokers.flash.created')
    else
      @errors = @honest_broker.errors
    end
  end

  def destroy
    respond_to :js

    @honest_broker = @group.lab_honest_brokers.find(params[:id])
    @honest_broker.destroy

    flash.now[:success] = t('groups.lab_honest_brokers.flash.destroyed')
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
  end

  def lab_honest_broker_params
    params.require(:lab_honest_broker).permit(
      :user_id,
      :group_id
    )
  end
end
