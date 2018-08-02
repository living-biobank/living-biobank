json.(@labs) do |lab|
  json.order_id         lab.order_id
  json.protocols        lab.protocols
  json.specimen_date    format_date(lab.specimen_date)
  json.specimen_source  lab.specimen_source
  json.mrn              lab.mrn
  json.actions          lab_actions(lab)
end
