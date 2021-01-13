class AddDiscardAgeToGroupsSource < ActiveRecord::Migration[5.2]
  def change
    add_column :groups_sources, :discard_age, :integer, after: :description
    add_column :groups_sources, :discard_note, :string, after: :discard_age
  end
end
