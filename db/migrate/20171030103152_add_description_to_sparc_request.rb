class AddDescriptionToSparcRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :sparc_requests, :description, :text, after: :title
  end
end
