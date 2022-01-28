$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#servicesTable').bootstrapTable('refresh')