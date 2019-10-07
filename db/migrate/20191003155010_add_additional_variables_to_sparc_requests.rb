class AddAdditionalVariablesToSparcRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :sparc_requests, :additional_variables, :boolean
  end
end
