class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    ActiveRecord::Base.transaction do
      populations = Population.all

      create_table :line_items do |t|
        t.integer     :sparc_request_id
        t.integer     :service_id
        t.integer     :sparc_id
        t.string      :service_source
        t.string      :query_name
        t.integer     :query_count
        t.string      :minimum_sample_size
        t.integer     :number_of_specimens_requested
        t.string      :status
        t.timestamps
      end

      #remove_reference :populations, :sparc_request, index: true, foreign_key: true
      #add_reference :populations, :line_item, index: true, foreign_key: true, before: :patient_id

      Population.reset_column_information

      SparcRequest.all.each do |request|
        li = LineItem.create(
          service_id:                     request.service_id,
          service_source:                 request.service_source,
          query_name:                     request.query_name,
          query_count:                    request.query_count,
          minimum_sample_size:            request.minimum_sample_size,
          number_of_specimens_requested:  request.number_of_specimens_requested
        )

        Population.where(sparc_request_id: request.id).update_all(line_item_id: li.id)
      end

      remove_column :sparc_requests, :service_id
      remove_column :sparc_requests, :service_source
      remove_column :sparc_requests, :query_name
      remove_column :sparc_requests, :query_count
      remove_column :sparc_requests, :minimum_sample_size
      remove_column :sparc_requests, :number_of_specimens_requested
      remove_column :sparc_requests, :line_item_id
    end
  end
end
