$('header').replaceWith("<%= j render 'sparc_requests/header' %>")
$('#requests').replaceWith("<%= j render 'sparc_requests/requests', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")

$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
