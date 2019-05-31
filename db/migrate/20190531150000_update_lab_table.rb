class UpdateLabTable < ActiveRecord::Migration[5.1]
  def change
  	add_column :labs, :line_item_id, :bigint
  	add_column :labs, :recipient_id, :bigint
  	add_column :labs, :released_at, :datetime
  	add_column :labs, :retrieved_at, :datetime
  	add_column :labs, :discarded_at, :datetime

  	drop_table :specimen_records
  end
end
