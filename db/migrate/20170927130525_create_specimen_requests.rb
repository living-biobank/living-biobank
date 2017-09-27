class CreateSpecimenRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :specimen_requests do |t|
      t.string :i2b2_query_name
      t.bigint :sparc_protocol_id
      t.integer :query_cnt

      t.timestamps
    end
  end
end
