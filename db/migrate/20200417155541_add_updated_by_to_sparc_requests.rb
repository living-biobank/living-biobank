class AddUpdatedByToSparcRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :sparc_requests, :updated_by, :bigint, after: :updated_at

    add_index :sparc_requests, :updated_by
  end
end
