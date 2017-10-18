class AddUserIdToSparcRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :sparc_requests, :user_id, :integer, after: :id
  end
end
