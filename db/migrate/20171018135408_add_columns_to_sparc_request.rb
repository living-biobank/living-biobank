class AddColumnsToSparcRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :sparc_requests, :service_id, :integer, :after => :primary_pi_email
    add_column :sparc_requests, :service_source, :string, :after => :primary_pi_email
    add_column :sparc_requests, :query_name, :string, :after => :primary_pi_email
  end
end
