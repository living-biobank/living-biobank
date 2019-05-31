class AddForeignKeystoLabsTable < ActiveRecord::Migration[5.1]
  def change
  	add_foreign_key :labs, :line_items, column: :line_item_id
  end
end
