$('#modalContainer').html("<%= j render 'specimen_records/form', patient: @patient, specimen_record: @specimen_record, lab: @lab %>")
setRequiredFields()
initializeSelectpickers()
$('#modalContainer').modal('show')
