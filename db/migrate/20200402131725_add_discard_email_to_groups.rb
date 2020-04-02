class AddDiscardEmailToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :discard_email, :text
  end
end
