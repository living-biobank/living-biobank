$('#modalContainer').html("<%= j render 'control_panel/groups/discard_form', group: @group %>")
$('#modalContainer').modal('show')
