$('#modalContainer').html("<%= j render 'control_panel/groups/form', group: @group %>")
$('#modalContainer').modal('show')
