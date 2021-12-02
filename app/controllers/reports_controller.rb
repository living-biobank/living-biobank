class ReportsController < ApplicationController
	def specimen_report
		@labs =
      if current_user.admin?
        Lab.all
      else
        current_user.honest_broker_labs
      end.filtered_for_index(report_params[:term], report_params[:specimen_date_start], report_params[:specimen_date_end], report_params[:status], report_params[:source], report_params[:sort_by], report_params[:sort_order]).eager_load(:releaser, :patient, source: :groups_sources)

		respond_to do |format|
			format.html
			format.csv { send_data @labs.to_csv, filename: "labs-#{Date.today}.csv", disposition: "attachment"}
		end
	end

	def sparc_request_report
		@requests = current_user.eligible_requests.filtered_for_index(params[:term], params[:status], params[:sort_by], params[:sort_order]).eager_load(:requester, specimen_requests: [:labs, :groups_source, :group]).preload(:primary_pi, :specimen_requests, protocol: { project_roles: :identity }, additional_services: [:service, :sub_service_request])

		respond_to do |format|
			format.html
			format.csv { send_data @requests.to_csv, filename: "requests-#{Date.today}.csv", disposition: "attachment"}
		end
	end

	private
		def report_params
			params.permit(
				:format,
				:term,
				:specimen_date_start,
				:specimen_date_end,
				:status,
				:source,
				:sort_by,
				:sort_order
			)
		end
end
