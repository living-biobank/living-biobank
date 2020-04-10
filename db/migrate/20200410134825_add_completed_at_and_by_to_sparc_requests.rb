class AddCompletedAtAndByToSparcRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :sparc_requests, :finalized_at, :datetime, after: :submitted_at
    add_column :sparc_requests, :finalized_by, :bigint, after: :finalized_at

    add_index :sparc_requests, :finalized_by

    add_column :sparc_requests, :completed_at, :datetime, after: :finalized_by
    add_column :sparc_requests, :completed_by, :bigint, after: :completed_at

    add_index :sparc_requests, :completed_by

    add_column :sparc_requests, :cancelled_at, :datetime, after: :completed_by
    add_column :sparc_requests, :cancelled_by, :bigint, after: :cancelled_at

    add_index :sparc_requests, :cancelled_by
  end
end
