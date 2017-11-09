class AddQuantityToSpecimenRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :specimen_records, :quantity, :integer
  end
end
