class AddProtocolIdToSparcRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :sparc_requests, :protocol_id, :integer, after: :status
  end
end
