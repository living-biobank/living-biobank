class CreatePopulations < ActiveRecord::Migration[5.1]
  def change
    create_table :populations do |t|
      t.references :specimen_request, foreign_key: true
      t.references :patient, foreign_key: true
      t.datetime :identified_date

      t.timestamps
    end
  end
end
