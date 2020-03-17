$('#modalContainer').modal('hide')
$('#user_management').replaceWith("<%= j render 'control_panel/users_panel', users: @users %>")
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")

$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix