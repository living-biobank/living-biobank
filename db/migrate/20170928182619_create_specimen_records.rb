class CreateSpecimenRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :specimen_records do |t|
      t.integer :protocol_id
      t.datetime :release_date
      t.string :release_to
      t.references :lab

      t.timestamps
    end
  end
end
