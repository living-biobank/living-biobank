class MigrateIntIdsToBigints < ActiveRecord::Migration[5.2]
  def up
    change_column :line_items, :sparc_request_id, :bigint
    change_column :line_items, :service_id, :bigint
    change_column :line_items, :sparc_id, :bigint

    change_column :services, :sparc_id, :bigint
  end
end
