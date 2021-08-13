class I2b2QueriesController < ApplicationController
  def index
    respond_to :js

    @queries = 
      if params[:protocol_id].present?
        protocol = SPARC::Protocol.find(params[:protocol_id])
        I2b2::Query.where(user_id: protocol.study_users.pluck(:ldap_uid) + (current_user.data_honest_broker? || current_user.admin? ? [current_user.net_id] : []))
      else
        requester = User.find(params[:user_id])
        I2b2::Query.where(user_id: requester.net_id)
        # I2b2::Query.where(user_id: "bah29@musc.edu")
      end.order(create_date: :desc)

    @shrine_queries = []
  end

  def show
    respond_to :js

    @query = I2b2::Query.find_by(query_master_id: params[:id])
  end
end
