class QueryNamesController < ApplicationController
  def index
    respond_to :js

    @queries = I2b2::QueryName.where(user_id: User.find(params[:user_id]).net_id).order(create_date: :desc)
  end
end
