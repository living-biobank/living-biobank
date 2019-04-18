<% if @errors %>
$("[id^='sparc_request_']").removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()

# Protocol Errors
<% @sparc_request.protocol.errors.keys.each do |attr| %>
<% @sparc_request.protocol.errors.full_messages_for(attr).each do |message| %>
$("#sparc_request_protocol_attributes_<%= attr.to_s %>").removeClass('is-valid').addClass('is-invalid').parents('.form-group').append("<small class='form-text form-error'><%= message %></small>")
<% end %>
<% end %>

# Primary PI Errors
<% @sparc_request.protocol.primary_pi_role.errors.full_messages_for(:identity).each do |message| %>
$('#primary_pi_search').removeClass('is-valid').addClass('is-invalid').parents('.form-group').append("<small class='form-text form-error'><%= message %></small>")
<% end %>

# Line Item Errors
<% @sparc_request.line_items.each_with_index do |line_item, index| %>
<% line_item.errors.keys.each do |attr| %>
<% line_item.errors.full_messages_for(attr).each do |message| %>
<% attr = :service_id if attr == :service %>
$(".nested_sparc_request_line_items:visible:nth(<%= index %>) [name*='[<%= attr.to_s %>]']").removeClass('is-valid').addClass('is-invalid').parents('.form-group').append("<small class='form-text form-error'><%= message %></small>")
<% end %>
<% end %>
<% end %>

<% else %>
$('#requests').replaceWith("<%= j render 'sparc_requests/table', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")
initializeSelectpickers()
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>
