class AddDeletedAtToLineItem < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :deleted_at, :datetime
    add_index :line_items, :deleted_at
  end
end
