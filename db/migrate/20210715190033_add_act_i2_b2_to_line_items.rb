class AddActI2B2ToLineItems < ActiveRecord::Migration[5.2]
  def change
    # Add column for ACT queries
    add_column :line_items, :act_query_id, :bigint, after: :query_id

    # Rename existing query id column to distinguis between the musc query and act queries
    rename_column :line_items, :query_id, :musc_query_id
  end
end
