$('#modalContainer').html("<%= j render 'lab_honest_brokers/form', honest_broker: @honest_broker %>")
$('#modalContainer').modal('show')
initializeHonestBrokerTypeahead()
