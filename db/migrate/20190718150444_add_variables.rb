class AddVariables < ActiveRecord::Migration[5.1]
  def change
    create_table :variables do |t|
      t.references  :group
      t.string      :name
      t.timestamps
    end

    add_index :variables, [:group_id, :name], unique: true
  end
end
