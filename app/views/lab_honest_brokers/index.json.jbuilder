json.rows (@honest_brokers) do |lhb|
  json.user     mobile_user_display(lhb.user)
  json.name     lhb.user.full_name
  json.email    lhb.user.email
  json.actions  remove_honest_broker_button(lhb)
end
