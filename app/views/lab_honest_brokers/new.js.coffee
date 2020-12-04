$('#modalContainer').html("<%= j render 'lab_honest_brokers/form', group: @group, honest_broker: @honest_broker %>")
$('#modalContainer').modal('show')
initializeHonestBrokerTypeahead()
