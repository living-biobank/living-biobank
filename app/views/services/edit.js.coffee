$('#modalContainer').html("<%= j render 'services/form', service: @service, group: @group, edit_form: true%>")
$('#modalContainer').modal('show')
$('select').selectpicker()