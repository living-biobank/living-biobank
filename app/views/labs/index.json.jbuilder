json.(@lab_groups) do |grouping, labs|
  json.mrn                grouping[:patient].mrn
  json.samples_available  labs.count
  json.specimen_source    grouping[:specimen_source]
  json.protocols          protocols_preview(grouping[:patient].protocols)
  json.actions            release_lab_button(grouping[:patient])
end
