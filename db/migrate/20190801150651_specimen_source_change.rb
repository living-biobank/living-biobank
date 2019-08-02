class SpecimenSourceChange < ActiveRecord::Migration[5.1]
  def change
    change_column :line_items, :service_source, :bigint
    add_foreign_key :line_items, :sources, column: :service_source
    change_column :labs, :specimen_source, :bigint
    add_foreign_key :labs, :sources, column: :specimen_source
  end
end
