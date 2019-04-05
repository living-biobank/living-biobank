<% if @errors %>
$("[id^='sparc_request_']").removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()

<% @errors.keys.each do |attr| %>
<% @errors.full_messages_for(attr).each do |message| %>
$("#sparc_request_<%= attr.to_s %>").removeClass('is-valid').addClass('is-invalid').parents('.form-group').append("<small class='form-text form-error'><%= message %></small>")
<% end %>
<% end %> 

# Line Item Errors
<% line_item_index = 0 %>
<% @line_item_params.each do |index, values| %>
<% unless values['_destroy'] %>
<% if li_errors = @sparc_request.line_items[index.to_i].errors %>
<% li_errors.keys.each do |attr| %>
<% li_errors.full_messages_for(attr).each do |message| %>
$("#sparc_request_line_items_attributes_<%= index %>_<%= attr.to_s %>").removeClass('is-valid').addClass('is-invalid').parents('.form-group').append("<small class='form-text form-error'><%= message %></small>")
<% end %>
<% end %>
<% end %>
<% line_item_index += 1 %>
<% end %>
<% end %>

<% else %>
$('#requests').replaceWith("<%= j render 'sparc_requests/table', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")
initializeSelectpickers()
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>
