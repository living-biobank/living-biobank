$('#modalContainer').html("<%= j render 'select_form', musc_queries: @musc_queries, specimen_option: @specimen_option %>")
$('#modalContainer').modal('show')
NProgress.done()