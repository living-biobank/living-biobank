class AddStatusToLabs < ActiveRecord::Migration[5.1]
  def change
  	add_column :labs, :status, :string, default: I18n.t(:labs)[:statuses][:available]
  end
end
