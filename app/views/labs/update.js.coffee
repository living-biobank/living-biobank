$('.lab-records').html("<%= j render 'labs/lab_records', labs: @labs %>")
swal("Success", "Lab has been removed", "success")
