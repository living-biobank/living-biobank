class AddQueryCountAndLineItemId < ActiveRecord::Migration[5.1]
  def change
    add_column :sparc_requests, :query_count, :integer, after: :number_of_specimens_requested
    add_column :sparc_requests, :line_item_id, :bigint, after: :protocol_id
  end
end
