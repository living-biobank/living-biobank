class CreateJoinTableSparcRequestsVariables < ActiveRecord::Migration[5.1]
  def change
    create_join_table :sparc_requests, :variables do |t|
      # t.index [:sparc_request_id, :variable_id]
      # t.index [:variable_id, :sparc_request_id]
    end
  end
end
