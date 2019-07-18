class AddSources < ActiveRecord::Migration[5.1]
  def change
    create_table :sources do |t|
      t.references  :group
      t.string      :key
      t.string      :value
      t.timestamps
    end

    add_index :sources, [:group_id, :key], unique: true
  end
end
