json.rows (@groups_sources) do |groups_source|
  json.actions      groups_source_actions(groups_source)
  json.description  groups_source.description
  json.discard_age  groups_source.formatted_discard_age
  json.name         groups_source.name
  json.source_key   groups_source.source.key
  json.source_value groups_source.source.value
end
