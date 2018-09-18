$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#requestsTable').bootstrapTable('refresh')
