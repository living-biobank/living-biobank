$('#modalContainer').html("<%= j render 'specimen_records/form', specimen_record: @specimen_record, lab: @lab %>")
setRequiredFields()
$('#modalContainer').modal('show')
