namespace :data do
  desc "Reorder existing specimen line items"
  task reorder_position: :environment do
    SparcRequest.all.each do |sparc_request|
      sparc_request.specimen_requests.each_with_index do |specimen_request, index|
        specimen_request.update_column :position, index + 1
      end
    end
  end
end
