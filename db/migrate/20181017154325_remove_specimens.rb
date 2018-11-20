class RemoveSpecimens < ActiveRecord::Migration[5.1]
  def up
    #remove_reference :populations, :specimen_request, index: true, foreign_key: true
    #add_reference :populations, :sparc_request, index: true, foreign_key: true, after: :id

    #drop_table :specimen
    #drop_table :specimen_requests
  end

  def down
    remove_reference :populations, :sparc_request, index: true, foreign_key: true
    add_reference :populations, :specimen_request, index: true, foreign_key: true, after: :id

    create_table :specimen do |t|
      t.references :specimen_request, foreign_key: true
      t.references :lab, foreign_key: true

      t.timestamps
    end

    create_table :specimen_requests do |t|
      t.string :i2b2_query_name
      t.bigint :sparc_protocol_id
      t.bigint :sparc_line_item_id
      t.integer :query_cnt

      t.timestamps
    end
  end
end
