class AddDefaultDiscardAge < ActiveRecord::Migration[5.2]
  def change
    GroupsSource.where(discard_age: nil).update_all(discard_age: 7)
  end
end
