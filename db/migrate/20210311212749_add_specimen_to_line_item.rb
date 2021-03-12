class AddSpecimenToLineItem < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :specimen, :boolean, default: false
    
    LineItem.where.not(groups_source: nil).each do |li|
      li.update(specimen: true)
    end
  end
end
