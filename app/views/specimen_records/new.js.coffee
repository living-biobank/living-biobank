$('#release').modal('show')
$('#release .modal-dialog').html("<%= j render 'form', specimen_record: @specimen_record, protocol_ids: @protocol_ids %>")
$('.datepicker').datepicker(format: 'yyyy-mm-dd')
