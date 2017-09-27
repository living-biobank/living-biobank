task fetch_biobank_records: :environment do

  submitted_line_items = LineItem.submitted_line_items(ENV.fetch('SERVICE_ID'))

  submitted_line_items.each do |line_item|
    SpecimenRequest.create(sparc_line_item_id: line_item.id,
                         sparc_protocol_id: line_item.protocol_id,
                         i2b2_query_name: line_item.i2b2_query,
                        )
  end
end

