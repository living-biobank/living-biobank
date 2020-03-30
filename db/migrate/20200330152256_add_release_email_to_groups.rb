class AddReleaseEmailToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :release_email, :text
  end
end
