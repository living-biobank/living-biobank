json.(@lab_groups) do |grouping, labs|
  json.mrn grouping[:patient].mrn
end
