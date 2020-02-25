class AddReleasedByToLabs < ActiveRecord::Migration[5.1]
  def change
    add_column :labs, :released_by, :bigint, after: :released_at

    add_index :labs, :released_by
  end
end
