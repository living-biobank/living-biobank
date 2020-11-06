$('#modalContainer').html("<%= j render 'control_panel/services/form', service: @service, group: @group, edit_form: true%>")
$('#modalContainer').modal('show')
$('select').selectpicker()