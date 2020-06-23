class QueryNamesController < ApplicationController
  def index
    respond_to :js

    @queries = 
      if params[:protocol_id].present?
        protocol = SPARC::Protocol.find(params[:protocol_id])
        I2b2::QueryName.where(user_id: protocol.study_users.pluck(:ldap_uid) + (current_user.data_honest_broker? || current_user.admin? ? [current_user.net_id] : []))
      else
        requester = User.find(params[:user_id])
        I2b2::QueryName.where(user_id: requester.net_id)
      end.order(create_date: :desc)
  end
end
