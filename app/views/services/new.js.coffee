$('#modalContainer').html("<%= j render 'services/form', service: @service, group: @group, edit_form: false%>")
$('#modalContainer').modal('show')
$('select').selectpicker()

