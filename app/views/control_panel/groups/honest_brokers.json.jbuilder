json.rows (@honest_brokers) do |user|
  json.user         mobile_user_display(user)
  json.name         user.full_name
  json.email        user.email
  json.remove       remove_honest_broker_button
end
