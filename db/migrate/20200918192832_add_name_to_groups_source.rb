class AddNameToGroupsSource < ActiveRecord::Migration[5.2]
  def change
    add_column :groups_sources, :name, :string, after: :id
  end
end
