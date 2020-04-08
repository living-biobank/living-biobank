json.rows (@users) do |user|
  json.user         mobile_user_display(user)
  json.name         user.full_name
  json.email        user.email
  json.privileges   user_privileges_display(user)
  json.groups       user_groups_display(user)
  json.actions      edit_user_button(user)
end
