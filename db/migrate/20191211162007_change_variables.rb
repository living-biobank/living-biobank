class ChangeVariables < ActiveRecord::Migration[5.1]
  def change
    drop_table :sparc_requests_variables

    remove_column :sparc_requests, :additional_variables
    add_reference :variables, :sparc_requests, index: true
  end
end
