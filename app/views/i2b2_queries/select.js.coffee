$('#modalContainer').html("<%= j render 'select_form', musc_queries: @musc_queries, shrine_queries: @shrine_queries, specimen_option: @specimen_option, musc_query_id: @musc_query_id, shrine_query_id: @shrine_query_id, protocol: @protocol, requester: @requester %>")
$('#modalContainer').modal('show')
NProgress.done()