$('#usersTable').bootstrapTable('refresh')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#modalContainer').modal('hide')
NProgress.done()
