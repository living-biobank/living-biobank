class AddConditionsToVariables < ActiveRecord::Migration[5.1]
  def change
    add_column :variables, :condition, :string
  end
end
