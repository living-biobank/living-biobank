class QueryNamesController < ApplicationController
  def index
    respond_to :js

    @queries = I2b2::QueryName.where(user_id: current_user.net_id).order(create_date: :desc)
  end
end
