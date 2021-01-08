json.rows (@services) do |service|
  json.actions      service_actions(service)
  json.condition    service.human_condition
  json.group_id     service.group_id
  json.id           service.id
  json.name         service.name
  json.organization service_org_hierarchy(service)
  json.position     service.position
  json.status       format_service_status(service)
end
