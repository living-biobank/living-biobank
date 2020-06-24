class AddQueryIdToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :query_id, :bigint, after: :source_id

    LineItem.where.not(query_name: nil).each do |li|
      if (queries = I2b2::Query.where(name: li.query_name)).length == 1
        li.update_attribute(:query_id, queries.first.query_master_id)
      end
    end
  end
end
