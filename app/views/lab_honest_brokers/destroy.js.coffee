$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#honestBrokersTable').bootstrapTable('refresh')
