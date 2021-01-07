class AddDescriptionToGroupsSource < ActiveRecord::Migration[5.2]
  def change
    add_column :groups_sources, :description, :string, after: :name
  end
end
