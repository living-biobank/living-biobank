funding_statuses  = PermissibleValue.get_hash('funding_status')
funding_sources   = PermissibleValue.get_hash('funding_source')

json.(@sparc_requests) do |sr|
  json.short_title          sr.short_title
  json.title                sr.title
  json.description          sr.description
  json.funding_status       funding_statuses[sr.funding_status]
  json.funding_source       funding_sources[sr.funding_source]
  json.start_date           format_date(sr.start_date)
  json.end_date             format_date(sr.end_date)
  json.primary_pi           sr.primary_pi_name
  json.service              sr.service.name
  json.service_source       sr.service_source
  json.specimens_requested  sr.number_of_specimens_requested
  json.minimum_sample       sr.minimum_sample_size
  json.query_name           sr.query_name
  json.time_estimate        request_time_estimate(sr)
  json.status               sr.status
  json.actions              request_actions(sr)            
end
