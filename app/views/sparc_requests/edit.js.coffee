$('#modalContainer').html("<%= j render 'sparc_requests/form', sparc_request: @sparc_request, is_draft: @is_draft %>")
initializePrimaryPITypeahead()
$("select[name*=query_id]").one 'rendered.bs.select', ->
  loadI2B2Queries()
$('#modalContainer').modal('show')
