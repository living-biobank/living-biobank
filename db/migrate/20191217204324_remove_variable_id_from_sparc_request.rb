class RemoveVariableIdFromSparcRequest < ActiveRecord::Migration[5.1]
  def change
    remove_column :sparc_requests, :variable_id
  end
end
