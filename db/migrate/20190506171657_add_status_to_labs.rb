class AddStatusToLabs < ActiveRecord::Migration[5.1]
  def change
  	add_column :labs, :status, :string
  end
end
