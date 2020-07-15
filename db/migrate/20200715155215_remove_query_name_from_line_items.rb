class RemoveQueryNameFromLineItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :line_items, :query_name
  end
end
