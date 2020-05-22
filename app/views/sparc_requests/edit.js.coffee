$('#modalContainer').html("<%= j render 'sparc_requests/form', sparc_request: @sparc_request, is_draft: @is_draft %>")
initializePrimaryPITypeahead()
loadI2B2Queries("<%= @sparc_request.requester.id %>")
$('#modalContainer').modal('show')
