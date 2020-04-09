class AddPositionToServicesAndVariables < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :position, :integer, after: :group_id
    add_column :variables, :position, :integer, after: :group_id
  end
end
