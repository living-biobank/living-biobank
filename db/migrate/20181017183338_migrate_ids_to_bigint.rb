class MigrateIdsToBigint < ActiveRecord::Migration[5.1]
  $models = {
    labs:             [:patient_id, :order_id, :visit_id, :lab_visit_id],
    populations:      [:sparc_request_id],
    sparc_requests:   [:user_id, :service_id, :protocol_id, :line_item_id],
    specimen_records: [:protocol_id, :service_id]
  }

  def up
    ActiveRecord::Base.transaction do
      $models.each do |table, columns|
        columns.each do |column|
          change_column table, column, :bigint
        end
      end
    end
  end

  def down
    ActiveRecord::Base.transaction do
      $models.each do |table, columns|
        columns.each do |column|
          change_column table, column, :integer
        end
      end
    end
  end
end
