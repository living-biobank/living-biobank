class AddIdentifierToPatients < ActiveRecord::Migration[5.1]
  def change
  	add_column :patients, :identifier, :string
  	add_column :patients, :dob, :date
  end
end
