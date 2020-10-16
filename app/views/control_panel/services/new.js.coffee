$('#modalContainer').html("<%= j render 'control_panel/services/form', service: @service, group: @group, edit_form: false%>")
$('#modalContainer').modal('show')
$('select').selectpicker()

