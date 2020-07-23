class DirectoryController < ApplicationController
  def index
    respond_to :json

    results = Directory.search(params[:term]).map{ |i| {
      label: i.display_name, value: i.net_id, email: i.email, id: i.id
    }}

    render json: results.to_json
  end
end
