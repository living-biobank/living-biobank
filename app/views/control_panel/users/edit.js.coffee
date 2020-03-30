$('#modalContainer').html("<%= j render 'control_panel/users/form', user: @user %>")
$('#modalContainer').modal('show')
