$('#modalContainer').html("<%= j render 'control_panel/groups/release_form', group: @group %>")
$('#modalContainer').modal('show')
