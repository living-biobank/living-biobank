class AddServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.references  :group
      t.integer     :sparc_id
      t.timestamps
    end
  end
end
