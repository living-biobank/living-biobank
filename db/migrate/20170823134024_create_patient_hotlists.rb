class CreatePatientHotlists < ActiveRecord::Migration[5.1]
  def change
    create_table :patient_hotlists do |t|
      t.string :mrn
      t.string :available_lab
      t.datetime :date_matched

      t.timestamps
    end
  end
end
