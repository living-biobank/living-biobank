class AddNamesToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :first_name, :string, after: :id
    add_column :users, :last_name, :string, after: :first_name
  end

  def down
    drop_column :users, :first_name
    drop_column :users, :last_name
  end
end
