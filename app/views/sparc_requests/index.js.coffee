$('#requests').replaceWith("<%= j render 'sparc_requests/table', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")
$('.selectpicker').selectpicker()
