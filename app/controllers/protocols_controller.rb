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
      @rmid_record = SPARC::Protocol.get_rmid(params[:rmid])

      if @rmid_record.nil?
        @error = t(:requests)[:form][:subtext][:rmid_server_down]
      elsif @rmid_record['status'] == 404
        @error = t(:requests)[:form][:subtext][:rmid_not_found]
      else
        @protocol = SPARC::Protocol.find_by(research_master_id: params[:rmid])
      end
    end
  end
end
