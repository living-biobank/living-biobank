class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.string :mrn
      t.datetime :preference_date
      t.string :contact_pref
      t.string :bio_bank_pref

      t.timestamps
    end
  end
end
