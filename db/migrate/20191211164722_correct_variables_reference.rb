class CorrectVariablesReference < ActiveRecord::Migration[5.1]
  def change
    remove_column :variables, :sparc_requests_id
    add_reference :sparc_requests, :variables, index: true
  end
end
