json.(@sparc_requests) do |sparc_request|
  json.short_title      sparc_request.short_title
  json.title            sparc_request.title
  json.funding_status   PermissibleValue.get_value('funding_status', sparc_request.funding_status)
  json.funding_source   PermissibleValue.get_value('funding_source', sparc_request.funding_source)
  json.start_date       format_date(sparc_request.start_date)
  json.end_date         format_date(sparc_request.end_date)
  json.primary_pi       sparc_request.primary_pi_name
  json.service          sparc_request.service.name
  json.service_source   sparc_request.service_source
  json.query_name       sparc_request.query_name
end
