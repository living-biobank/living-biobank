class I2b2QueriesController < ApplicationController
  before_action :find_requester, only: [:index, :select]

  def index
    respond_to :js

    @musc_queries = 
      if params[:protocol_id].present?
        protocol = SPARC::Protocol.find(params[:protocol_id])
        I2b2::Query.where(user_id: protocol.study_users.pluck(:ldap_uid) + (current_user.data_honest_broker? || current_user.admin? ? [current_user.net_id] : []))
      else
        I2b2::Query.where(user_id: @requester.net_id)
      end.order(create_date: :desc)

    @shrine_queries = 
      Shrine::Query.where(username: @requester.net_id.split('@').first)
  end

  def show
    respond_to :js

    if params[:query_type] == 'musc'
      @musc_query = I2b2::Query.find_by(query_master_id: params[:id])
    elsif params[:query_type] == 'shrine'
      @shrine_query = Shrine::Query.find(params[:id])
    end
  end

  def select
    respond_to :js

    @specimen_option = params[:specimen_option]

    @musc_queries = 
      if params[:protocol_id].present?
        protocol = SPARC::Protocol.find(params[:protocol_id])
        I2b2::Query.where(user_id: protocol.study_users.pluck(:ldap_uid) + (current_user.data_honest_broker? || current_user.admin? ? [current_user.net_id] : []))
      else
        I2b2::Query.where(user_id: @requester.net_id)
      end.order(create_date: :desc)

    @shrine_queries = 
      Shrine::Query.where(username: @requester.net_id.split('@').first)
  end

  def save_selection

  end

  private
    def find_requester
      @requester = User.find(params[:user_id])
    end
end
