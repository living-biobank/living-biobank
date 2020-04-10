class AddDiscardedByToLabs < ActiveRecord::Migration[5.2]
  def change
    add_column :labs, :discarded_by, :bigint, after: :discarded_at

    add_index :labs, :discarded_by
  end
end
