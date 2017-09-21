class CreateBiobankRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :biobank_records do |t|
      t.integer :line_item_id
      t.integer :protocol_id
      t.text :i2b2_query
      t.integer :service_id

      t.timestamps
    end
  end
end
