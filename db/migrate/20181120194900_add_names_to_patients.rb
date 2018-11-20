class AddNamesToPatients < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :lastname, :string, after: :mrn
    add_column :patients, :firstname, :string, after: :lastname
  end
end
