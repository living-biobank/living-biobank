if $('#userManagement').length # Filtering
  $('#usersTable').replaceWith("<%= j render 'control_panel/users/table' %>")
  $('.pagination').replaceWith("<%= j render 'layouts/pagination', records: @users, filter_params: user_filter_params.merge({ controller: 'users', action: 'index' }) %>")
