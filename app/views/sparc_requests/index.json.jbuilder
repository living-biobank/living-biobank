json.(@sparc_requests) do |sr|
  json.title            sr.title
  json.description      sr.description
  json.start_date       format_date(sr.start_date)
  json.end_date         format_date(sr.end_date)
  json.primary_pi       sparc_request.primary_pi_name
  json.service          sparc_request.service.name
  json.service_source   sparc_request.service_source
  json.quantity         sr.number_of_specimens_requested
  json.minimum_sample   sr.minimum_sample_size
  json.query_name       sparc_request.query_name
  json.time_estimate    request_time_estimate(sr)
  json.status           sr.status
end
