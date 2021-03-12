class UpdateExistingLineItemsWithPosition < ActiveRecord::Migration[5.2]
  def change
    SparcRequest.all.each do |sparc_request|
      sparc_request.specimen_requests.order(:updated_at).each.with_index(1) do |specimen_request, index|
        specimen_request.update_column :position, index
      end
    end
  end
end
