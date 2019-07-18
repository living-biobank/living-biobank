class AddVariables < ActiveRecord::Migration[5.1]
  def change
    create_table :variables do |t|
      t.references  :group
      t.string      :name
      t.timestamps
    end
  end
end
