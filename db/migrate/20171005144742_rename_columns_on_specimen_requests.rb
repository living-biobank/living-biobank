class RenameColumnsOnSpecimenRequests < ActiveRecord::Migration[5.1]
  def change
    rename_column(:specimen_requests, :sparc_line_item_id, :line_item_id)
    rename_column(:specimen_requests, :sparc_protocol_id, :protocol_id)
  end
end
