class AddDiscardAgeToGroupsSource < ActiveRecord::Migration[5.2]
  def change
    add_column :groups_sources, :discard_age, :integer, after: :description
  end
end
