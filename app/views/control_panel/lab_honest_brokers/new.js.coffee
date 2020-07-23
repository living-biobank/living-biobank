$('#modalContainer').html("<%= j render 'control_panel/lab_honest_brokers/form', honest_broker: @honest_broker %>")
$('#modalContainer').modal('show')
initializeHonestBrokerTypeahead()
