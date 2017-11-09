class SpecimenRecordChanges < ActiveRecord::Migration[5.1]
  def change
    remove_column :specimen_records, :lab_id
    add_column :specimen_records, :mrn, :string
    add_column :specimen_records, :service_source, :string
    add_column :specimen_records, :service_id, :integer
  end
end
