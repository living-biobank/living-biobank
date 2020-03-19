$('#modalContainer').html("<%= j render 'permissions/form', user: @user, groups: @groups %>")
$('#modalContainer').modal('show')

