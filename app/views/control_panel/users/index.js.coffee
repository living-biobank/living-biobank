if $('#userManagement').length # Filtering
  $('#usersTable').replaceWith("<%= j render 'control_panel/users/table' %>")
  $('.pagination').replaceWith("<%= j render 'layouts/pagination', records: @users, filter_params: user_filter_params.merge({ controller: 'users', action: 'index' }) %>")
else # Changing tab
  $('.control-panel-nav').replaceWith("<%= j render 'control_panel/nav_links' %>")
  $('.control-panel-container').replaceWith("<%= j render 'control_panel/users/users_panel', users: @users %>")
  $(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
  window.history.pushState({}, null, "<%= control_panel_users_path %>")
