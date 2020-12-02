class Sparc::DirectoryController < ApplicationController
  def index
    respond_to :json

    results = SPARC::Directory.search(params[:term]).map{ |i| {
      label: i.display_name, value: i.suggestion_value, email: i.email, id: i.id
    }}

    render json: results.to_json
  end
end
