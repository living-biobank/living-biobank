class ShrineQueriesController < ApplicationController
  def index
    respond_to :js

    @queries = 
      if params[:protocol_id].present?
        protocol = SPARC::Protocol.find(params[:protocol_id])
        Shrine::Query.where(user_id: protocol.study_users.pluck(:ldap_uid) + (current_user.data_honest_broker? || current_user.admin? ? [current_user.net_id] : []))
      else
        requester = User.find(params[:user_id])
        Shrine::Query.where(user_id: requester.net_id)
      end.order(create_date: :desc)
  end

  def show
    respond_to :js

    @query = Shrine::Query.find_by(query_master_id: params[:id])
  end
end
