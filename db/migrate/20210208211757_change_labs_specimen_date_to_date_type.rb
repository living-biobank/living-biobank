class ChangeLabsSpecimenDateToDateType < ActiveRecord::Migration[5.2]
  def change
    change_column :labs, :specimen_date, :date
  end
end
