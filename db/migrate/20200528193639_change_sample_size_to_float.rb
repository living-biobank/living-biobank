class ChangeSampleSizeToFloat < ActiveRecord::Migration[5.2]
  def change
    LineItem.all.each do |li|
      unless li.minimum_sample_size == nil
        new_sample_size = li.minimum_sample_size.delete!('^0-9.')
        li.update_attribute('minimum_sample_size', new_sample_size.blank? ? nil : new_sample_size)
      end
    end

    change_column :line_items, :minimum_sample_size, :decimal, precision: 8, scale: 2
  end
end
