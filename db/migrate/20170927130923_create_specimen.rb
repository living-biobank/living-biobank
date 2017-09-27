class CreateSpecimen < ActiveRecord::Migration[5.1]
  def change
    create_table :specimen do |t|
      t.references :specimen_request, foreign_key: true
      t.references :lab_id, foreign_key: true

      t.timestamps
    end
  end
end
