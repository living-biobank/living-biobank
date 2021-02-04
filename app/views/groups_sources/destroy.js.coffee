$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#groupsSourcesTable').bootstrapTable('refresh')
