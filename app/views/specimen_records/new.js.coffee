$('#release').modal('show')
$('#release .modal-dialog').html("<%= j render 'form', specimen_record: @specimen_record, lab: @lab %>")
$('.datepicker').datepicker();
