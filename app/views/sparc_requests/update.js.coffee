<% if @errors %>
<% if @sparc_request.draft? %>
$("[id^='sparc_request_protocol_'], [id=primary_pi_search]").parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% else %>
$("[id^='sparc_request_'], [id=primary_pi_search]").parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% end %>

# Data Request Consult Error
<% @errors[:dr_consult].each do |message| %>
$("#sparc_request_dr_consult").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>

# Protocol Errors
<% @sparc_request.protocol.errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$("#sparc_request_protocol_attributes_<%= attr.to_s %>").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>

# Primary PI Errors
<% @sparc_request.protocol.primary_pi_role.errors.messages[:identity].each do |message| %>
$('#primary_pi_search').parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>

# Line Item Errors
<% if @sparc_request.draft? %>
<% @sparc_request.specimen_requests.each_with_index do |line_item, index| %>
$(".nested_sparc_request_specimen_requests:visible:nth(<%= index %>) [name*='[source_id]']").parents('.form-group').removeClass('is-valid')
$(".nested_sparc_request_specimen_requests:visible:nth(<%= index %>) [name*='[query_name]']").parents('.form-group').removeClass('is-valid')
$(".nested_sparc_request_specimen_requests:visible:nth(<%= index %>) [name*='[number_of_specimens_requested]']").parents('.form-group').removeClass('is-valid')
$(".nested_sparc_request_specimen_requests:visible:nth(<%= index %>) [name*='[minimum_sample_size]']").parents('.form-group').removeClass('is-valid')
<% end %>
<% else %>
<% @sparc_request.specimen_requests.each_with_index do |line_item, index| %>
<% line_item.errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$(".nested_sparc_request_specimen_requests:visible:nth(<%= index %>) [name*='[<%= attr.to_s %>]']").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>
<% end %>
<% end %>

<% else %>
$('#requestFilters').replaceWith("<%= j render 'sparc_requests/filters' %>")
$('#requests').replaceWith("<%= j render 'sparc_requests/requests', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")
initializeSelectpickers()
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>
