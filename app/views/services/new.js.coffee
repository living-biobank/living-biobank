$('#modalContainer').html("<%= j render 'services/form', service: @service, group: @group %>")
$('#modalContainer').modal('show')
initializeServiceTypeahead()
