class AddPositionToLineItem < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :position, :integer
  end
end
