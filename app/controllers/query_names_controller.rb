class QueryNamesController < ApplicationController
  def index
    respond_to :js

    @queries = 
      if params[:request_id]
        request = SparcRequest.find(params[:request_id])
        I2b2::QueryName.where(user_id: request.protocol.study_users.pluck(:ldap_uid))
      else
        requester = User.find(params[:user_id])
        I2b2::QueryName.where(user_id: requester.net_id)
      end.order(create_date: :desc)
  end
end
