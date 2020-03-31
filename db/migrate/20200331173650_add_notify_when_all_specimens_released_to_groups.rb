class AddNotifyWhenAllSpecimensReleasedToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :notify_when_all_specimens_released, :boolean, after: :process_sample_size
  end
end
