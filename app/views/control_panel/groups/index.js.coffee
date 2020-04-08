if $('#groupManagement').length # Filtering
  $('#groupsTable').replaceWith("<%= j render 'control_panel/groups/table' %>")
  $('.pagination').replaceWith("<%= j render 'control_panel/groups/pagination', groups: @groups %>")
else # Changing tab
  $('.control-panel-nav').replaceWith("<%= j render 'control_panel/nav_links' %>")
  $('.control-panel-container').replaceWith("<%= j render 'control_panel/groups/groups_panel', groups: @groups %>")
  $(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
  window.history.pushState({}, null, "<%= control_panel_groups_path %>")
