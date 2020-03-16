$('#modalContainer').html("<%= j render 'control_panel/change_permissions', user: @user, groups: @groups %>")
$('#modalContainer').modal('show')
$('#submit_changes').click ->
  $('#modalContainer').modal('hide')
