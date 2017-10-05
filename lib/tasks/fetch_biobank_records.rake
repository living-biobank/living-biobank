task fetch_biobank_records: :environment do

  submitted_line_items = LineItem.submitted_line_items(ENV.fetch('SERVICE_ID'))

  submitted_line_items.each do |line_item|
    sr = SpecimenRequest.where(line_item_id: line_item.id).first_or_create
    sr.update_attributes(line_item_id: line_item.id,
                         protocol_id: line_item.protocol.id,
                         i2b2_query_name: line_item.i2b2_query
                        )
  end
end

