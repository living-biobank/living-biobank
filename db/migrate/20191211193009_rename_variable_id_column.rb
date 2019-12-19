class RenameVariableIdColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :sparc_requests, :variables_id, :variable_id
  end
end
