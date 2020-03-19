$('#user_management').replaceWith("<%= j render 'control_panel/users_panel', users: @users %>")
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#modalContainer').modal('hide')

$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix