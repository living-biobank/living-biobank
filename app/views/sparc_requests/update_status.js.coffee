$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#requestFilters').replaceWith("<%= j render 'sparc_requests/filters' %>")

<% if Rails.application.routes.recognize_path(request.referrer)[:action] == 'show' %>
$('.request').replaceWith("<%= j render 'sparc_requests/request', request: @sparc_request %>")
<% else %>
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")
$('#requests').replaceWith("<%= j render 'sparc_requests/requests', requests: @requests %>")
<% end %>

loadI2B2Queries()

$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
