task fetch_biobank_records: :environment do

  biobank_records = HTTParty.get(
    "https://api-sparc.musc.edu/line_items.json?service_id=#{ENV.fetch('SERVICE_ID')}",
    timeout: 500, headers: {'Content-Type' => 'application/json'})

  biobank_records.each do |br|
    BiobankRecord.create(line_item_id: br['biobank_record']['line_item_id'],
                         protocol_id: br['biobank_record']['protocol_id'],
                         i2b2_query: br['biobank_record']['i2b2_query'],
                         service_id: br['biobank_record']['service_id']
                        )
  end

end
