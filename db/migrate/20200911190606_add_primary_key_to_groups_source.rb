class AddPrimaryKeyToGroupsSource < ActiveRecord::Migration[5.2]
  def change
    add_column :groups_sources, :id, :primary_key, first: true
    add_column :groups_sources, :deprecated, :boolean, default: false

    GroupsSource.reset_column_information
  end
end
