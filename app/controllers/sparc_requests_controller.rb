class SparcRequestsController < ApplicationController
  before_action :find_request,  only: [:show, :edit, :update, :destroy, :update_status]
  before_action :find_requests, only: [:index]

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    respond_to :html
  end

  def new
    respond_to :html, :js
    @sparc_request = current_user.sparc_requests.new
    @sparc_request.build_protocol(type: current_user.internal? ? 'Study' : 'Project', selected_for_epic: false)
    @sparc_request.protocol.build_primary_pi_role
    @sparc_request.protocol.primary_pi_role.build_identity
    @sparc_request.protocol.build_research_types_info
    @sparc_request.specimen_requests.build
  end

  def create
    @sparc_request = current_user.sparc_requests.new(sparc_request_params)

    if params[:save_draft]
      if @sparc_request.protocol.valid?
        @sparc_request.status = 'draft'
        @sparc_request.specimen_requests.each{ |sr| sr.groups_source_id ||= 0 }
        @sparc_request.save(validate: false)
        flash.now[:success] = t(:requests)[:saved]
      else
        @sparc_request.status = 'draft'
        @sparc_request.protocol.errors.add(:research_master_id, :invalid)
        @errors = @sparc_request.protocol.errors
      end
    else
      @sparc_request.status = 'pending'
      if @sparc_request.save
        send_submission_emails()
        flash.now[:success] = t(:requests)[:created]
      else
        @errors = @sparc_request.errors
      end
    end

    # Add the user only to a *NEW* SPARC Study if they're not the Primary PI
    
    # For Internal Users
    if current_user.internal?
      if @sparc_request.protocol.saved_change_to_attribute?(:id) && @sparc_request.protocol.primary_pi.ldap_uid != current_user.net_id
        @sparc_request.protocol.project_roles.create(identity: SPARC::Directory.find_or_create(current_user.net_id), role: 'research-assistant-coordinator', project_rights: 'approve')
      end
    else
      if @sparc_request.protocol.saved_change_to_attribute?(:id) && @sparc_request.protocol.primary_pi.attributes.slice('first_name', 'last_name', 'email') != current_user.attributes.slice('first_name', 'last_name', 'email')
        @sparc_request.protocol.project_roles.create(identity: SPARC::Identity.where(last_name: current_user.last_name, first_name: current_user.first_name, email:  current_user.email).first_or_create, role: 'research-assistant-coordinator', project_rights: 'approve')
      end
    end

    find_requests

    respond_to :js
  end

  def edit
    respond_to :html, :js
    @is_draft = @sparc_request.draft?

    if @sparc_request.specimen_requests.none?
      @sparc_request.specimen_requests.build
    end
  end

  def update
    if params[:save_draft]
      @sparc_request.assign_attributes(sparc_request_params)
      @sparc_request.specimen_requests.each{ |sr| sr.groups_source_id ||= 0 }
      
      if @sparc_request.protocol.valid? && @sparc_request.save(validate: false)
        flash.now[:success] = t(:requests)[:saved]
      else
        @errors = @sparc_request.errors
      end
    else
      if @sparc_request.draft?
        params[:sparc_request][:status] = 'pending'
      else
        params[:sparc_request][:updated_by] = current_user.id
      end

      if @sparc_request.update_attributes(sparc_request_params)
        if @sparc_request.updater.present?
          flash.now[:success] = t(:requests)[:updated]
        else
          send_submission_emails()
          flash.now[:success] = t(:requests)[:created]
        end
        send_admin_update_emails() if current_user != @sparc_request.requester
      else
        @errors = @sparc_request.errors
      end
    end

    find_requests

    respond_to :js
  end

  def update_status
    @sparc_request.assign_attributes(sparc_request_params)

    # Ignore validations, specifically for Draft requests
    if @sparc_request.save(validate: false)
      send_completion_emails() if @sparc_request.completed?
      flash.now[:success] = t(:requests)[:updated]
    else
      flash.now[:error] = t(:requests)[:failed]
    end

    find_requests

    respond_to :js
  end

  private

  def find_request
    @sparc_request = SparcRequest.find(params[:id])
  end

  def find_requests
    @requests       = current_user.eligible_requests.filtered_for_index(params[:term], params[:status], params[:sort_by], params[:sort_order]).paginate(page: params[:page].present? ? params[:page] : 1).eager_load(:requester, specimen_requests: [:labs, :groups_source, :group]).preload(:primary_pi, :specimen_requests, protocol: { project_roles: :identity }, additional_services: [:service, :sub_service_request])
    @draft_requests = current_user.eligible_requests.draft.preload(protocol: { project_roles: :identity })
  end

  def send_submission_emails
    RequestMailer.with(user: current_user, request: @sparc_request).confirmation_email.deliver_later
    unless @sparc_request.requester.net_id == @sparc_request.protocol.primary_pi.ldap_uid
      RequestMailer.with(user: @sparc_request.protocol.primary_pi, request: @sparc_request).pi_email.deliver_later
    end
  end

  def send_admin_update_emails
    RequestMailer.with(request: @sparc_request, user: @sparc_request.requester).admin_update_email.deliver_later
    unless @sparc_request.requester == @sparc_request.primary_pi
      RequestMailer.with(request: @sparc_request, user: @sparc_request.primary_pi).admin_update_email.deliver_later
    end
  end

  def send_completion_emails
    RequestMailer.with(completer: current_user, request: @sparc_request).completion_email.deliver_later
  end

  def sparc_request_params
    if params[:sparc_request][:protocol_attributes]
      params[:sparc_request][:protocol_attributes][:start_date] = sanitize_date(params[:sparc_request][:protocol_attributes][:start_date]) if params[:sparc_request][:protocol_attributes][:start_date]
      params[:sparc_request][:protocol_attributes][:end_date]   = sanitize_date(params[:sparc_request][:protocol_attributes][:end_date]) if params[:sparc_request][:protocol_attributes][:end_date]

      # Prvent the user from creating multiple new protocols by setting the Protocol ID on subsequent submits
      if (rmid = params[:sparc_request][:protocol_attributes][:research_master_id]) && !params[:sparc_request][:protocol_id] && (protocol = SPARC::Protocol.find_by(research_master_id: rmid))
        params[:sparc_request][:protocol_id]              = protocol.id
        params[:sparc_request][:protocol_attributes][:id] = protocol.id
      end
    end

    params.require(:sparc_request).except(:user_id).permit(
      :id,
      :protocol_id,
      :status,
      :finalized_at,
      :finalized_by,
      :updated_by,
      :completed_by,
      :cancelled_by,
      :dr_consult,
      protocol_attributes: [
        :id,
        :research_master_id,
        :type,
        :selected_for_epic,
        :short_title,
        :title,
        :brief_description,
        :funding_status,
        :funding_source,
        :potential_funding_source,
        :start_date,
        :end_date,
        :sponsor_name,
        primary_pi_role_attributes: [
          :id,
          :identity_id,
          identity_attributes: [
            :last_name,
            :first_name,
            :email
          ]
        ],
        research_types_info_attributes: [
          :id,
          :human_subjects
        ]
      ],
      specimen_requests_attributes: [
        :id,
        :groups_source_id,
        :query_id,
        :act_query_id,
        :number_of_specimens_requested,
        :minimum_sample_size,
        :_destroy
      ]
    )
  end
end
