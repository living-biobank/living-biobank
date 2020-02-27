$('#modalContainer').html("<%= j render 'control_panel/change_permissions', user: @user, groups: @groups %>")
$('#modalContainer').modal('show')