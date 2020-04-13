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
        render json: { error: t(:requests)[:form][:subtext][:rmid_server_down], status: 505 }, status: 503
      elsif @rmid_record['status'] == 404
        render json: { error: t(:requests)[:form][:subtext][:rmid_not_found], status: 404 }, status: 404
      else
        unless @protocol = SPARC::Protocol.find_by(research_master_id: params[:rmid])
          primary_pi = SPARC::Directory.find_or_create(@rmid_record['principal_investigator']['net_id'])

          render json: { title: @rmid_record['long_title'], short_title: @rmid_record['short_title'], primary_pi: { id: primary_pi.id, display_name: primary_pi.display_name }, status: 202 }, status: 202
        end
      end
    end
  end
end
