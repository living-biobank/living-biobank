$('#userManagement').replaceWith("<%= j render 'control_panel/users/users_panel', users: @users %>")
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#modalContainer').modal('hide')
