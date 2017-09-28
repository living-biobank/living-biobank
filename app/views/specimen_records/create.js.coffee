$('.lab-records').html("<%= j render 'labs/lab_records', labs: @labs %>")
$('#release').modal('hide')
swal("Specimen Released", "Specimen has been released", "success")
