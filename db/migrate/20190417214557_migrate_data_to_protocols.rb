class MigrateDataToProtocols < ActiveRecord::Migration[5.1]
  def up
    ActiveRecord::Base.transaction do
      SparcRequest.eager_load(:requester).where(protocol_id: nil).each do |sparc_request|
        p = SPARC::Project.create(
          short_title:              sparc_request.read_attribute(:short_title),
          title:                    sparc_request.read_attribute(:title),
          brief_description:        sparc_request.read_attribute(:description),
          funding_status:           sparc_request.read_attribute(:funding_status),
          funding_source:           sparc_request.read_attribute(:funding_status) == 'funded' ? sparc_request.read_attribute(:funding_source) : nil,
          potential_funding_source: sparc_request.read_attribute(:funding_status) == 'funded' ? nil : sparc_request.read_attribute(:funding_source),
          start_date:               sparc_request.read_attribute(:start_date),
          end_date:                 sparc_request.read_attribute(:end_date)
        )

        pi = SPARC::ProjectRole.create(
          protocol:       p,
          identity:       SPARC::Directory.find_or_create("#{sparc_request.primary_pi_netid}@#{SPARC::Directory.domain}"),
          role:           'primary-pi',
          project_rights: 'approve'
        )

        # Runs #update_sparc_records after_save to handle requests and line items
        sparc_request.update_attribute(:protocol, p)
      end
    end

    remove_column :sparc_requests, :short_title
    remove_column :sparc_requests, :title
    remove_column :sparc_requests, :description
    remove_column :sparc_requests, :funding_status
    remove_column :sparc_requests, :funding_source
    remove_column :sparc_requests, :start_date
    remove_column :sparc_requests, :end_date
    remove_column :sparc_requests, :primary_pi_netid
    remove_column :sparc_requests, :primary_pi_name
    remove_column :sparc_requests, :primary_pi_email
    remove_column :sparc_requests, :time_estimate
  end
end
