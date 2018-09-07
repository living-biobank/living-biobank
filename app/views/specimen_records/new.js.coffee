$('#modalContainer').html("<%= j render 'specimen_records/form', patient: @patient, specimen_record: @specimen_record, lab: @lab %>")
setRequiredFields()
$('.selectpicker').selectpicker()
$('#modalContainer').modal('show')
