class ProtocolsController < ApplicationController
  def index
    respond_to :json

    results = SPARC::Protocol.search(params[:term]).order(id: :desc).map{ |p| {
      id: p.id, label: p.identifier
    }}

    render json: results.to_json
  end

  def show
    respond_to :js

    if params[:id]
      @protocol = SPARC::Protocol.find(params[:id])
    elsif SPARC::Setting.get_value('research_master_enabled') && params[:rmid]
      begin
        @rmid_record = HTTParty.get("#{SPARC::Setting.get_value('research_master_api')}research_masters/#{params[:rmid]}.json",
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Token token=\"#{SPARC::Setting.get_value('rmid_api_token')}\""
          })
        if @rmid_record['status'] == 404
          @error = t(:requests)[:form][:subtext][:rmid_not_found]
        else
          @protocol = SPARC::Protocol.find_by(research_master_id: params[:rmid])
        end
      rescue
        @error = t(:requests)[:form][:subtext][:rmid_server_down]
      end
    end
  end
end
