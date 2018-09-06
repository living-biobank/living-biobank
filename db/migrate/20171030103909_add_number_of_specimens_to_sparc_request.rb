class AddNumberOfSpecimensToSparcRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :sparc_requests, :number_of_specimens_requested, :integer, after: :service_id
    add_column :sparc_requests, :minimum_sample_size, :string, after: :service_id
    add_column :sparc_requests, :status, :string, default: 'New', after: :service_id
    add_column :sparc_requests, :time_estimate, :string, after: :service_id
  end
end
