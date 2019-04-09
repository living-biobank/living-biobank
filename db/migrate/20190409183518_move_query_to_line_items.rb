class MoveQueryToLineItems < ActiveRecord::Migration[5.1]
  def up
    sparc_requests = SparcRequest.all

    remove_column :sparc_requests, :query_name
    remove_column :sparc_requests, :query_count

    add_column :line_items, :query_name, :string, after: :service_source
    add_column :line_items, :query_count, :integer, after: :query_name

    LineItem.reset_column_information

    sparc_requests.each do |request|
      request.line_items.update_all(query_name: request.query_name, query_count: request.query_count)
    end
  end
end
