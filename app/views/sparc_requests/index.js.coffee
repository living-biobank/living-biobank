$('header').replaceWith("<%= j render 'sparc_requests/header', request: nil %>")
$('#requests').replaceWith("<%= j render 'sparc_requests/requests', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")

<% if @requests.present? %>
loadI2B2Queries()
<% end %>

$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
