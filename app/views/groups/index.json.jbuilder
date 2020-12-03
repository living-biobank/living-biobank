json.rows (@groups) do |group|
  json.name     group.name
  json.sources  group_sources_display(group)
  json.services group_services_display(group)
  json.actions  edit_group_button(group)
end
