$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#requests').replaceWith("<%= j render 'sparc_requests/table', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")
initializeSelectpickers()
