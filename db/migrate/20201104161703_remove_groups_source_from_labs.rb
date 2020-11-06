class RemoveGroupsSourceFromLabs < ActiveRecord::Migration[5.2]
  def change
    remove_column :labs, :groups_source_id
  end
end
