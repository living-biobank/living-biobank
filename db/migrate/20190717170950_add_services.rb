class AddServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.references  :group
      t.integer     :sparc_id
      t.timestamps
    end

    add_index :services, [:group_id, :sparc_id], unique: true
  end
end
