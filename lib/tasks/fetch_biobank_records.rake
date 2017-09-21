task fetch_biobank_records: :environment do

  submitted_line_items = LineItem.submitted_line_items(ENV.fetch('SERVICE_ID'))

  submitted_line_items.each do |line_item|
    BiobankRecord.create(line_item_id: line_item.id,
                         protocol_id: line_item.protocol_id,
                         i2b2_query: line_item.i2b2_query,
                         service_id: line_item.service_id
                        )
  end
end

