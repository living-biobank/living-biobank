class AddRemovedToLabs < ActiveRecord::Migration[5.1]
  def change
    add_column :labs, :removed, :boolean, after: :specimen_source, default: false
  end
end
