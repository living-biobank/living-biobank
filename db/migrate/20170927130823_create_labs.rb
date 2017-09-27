class CreateLabs < ActiveRecord::Migration[5.1]
  def change
    create_table :labs do |t|
      t.references :patient, foreign_key: true
      t.datetime :specimen_date
      t.integer :order_id
      t.string :specimen_source

      t.timestamps
    end
  end
end
