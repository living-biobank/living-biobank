class CreateI2b2QueryLists < ActiveRecord::Migration[5.1]
  def change
    create_table :i2b2_query_lists do |t|
      t.text :query
      t.string :query_name
      t.belongs_to :protocol, foreign_key: true

      t.timestamps
    end
  end
end
