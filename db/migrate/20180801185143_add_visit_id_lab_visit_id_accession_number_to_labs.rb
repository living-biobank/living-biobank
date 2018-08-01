class AddVisitIdLabVisitIdAccessionNumberToLabs < ActiveRecord::Migration[5.1]
  def up
    add_column :labs, :visit_id, :integer
    add_column :labs, :lab_visit_id, :integer
    add_column :labs, :accession_number, :string, limit: 75
  end

  def down
    remove_column :labs, :visit_id
    remove_column :labs, :lab_visit_id
    remove_column :labs, :accession_number
  end
end
