$('#modalContainer').html("<%= j render 'permissions/change_permissions', user: @user, groups: @groups %>")
$('#modalContainer').modal('show')

