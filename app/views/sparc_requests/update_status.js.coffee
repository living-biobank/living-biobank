$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#requests').replaceWith("<%= j render 'sparc_requests/requests', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")

$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
