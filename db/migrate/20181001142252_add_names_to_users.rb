class AddNamesToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :first_name, :string, after: :id
    add_column :users, :last_name, :string, after: :first_name
  end

  def down
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
