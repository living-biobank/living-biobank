$('.control-panel-nav').replaceWith("<%= j render 'control_panel/nav_links' %>")
$('.control-panel-container').replaceWith("<%= j render 'control_panel/users/users_panel', users: @users %>")
$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix

window.history.pushState({}, null, "<%= control_panel_users_path %>")
