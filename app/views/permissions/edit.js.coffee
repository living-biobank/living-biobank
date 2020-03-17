$('#modalContainer').html("<%= j render 'permissions/change_permissions', user: @user, groups: @groups %>")
$('#modalContainer').modal('show')
$('#submit_changes').click ->
  $('#modalContainer').modal('hide')
