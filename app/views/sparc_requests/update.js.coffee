<% if @errors %>
$("[id^='sparc_request_']").removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% @errors.keys.each do |attr| %>
<% @errors.full_messages_for(attr).each do |message| %>
$("#sparc_request_<%= attr.to_s %>").removeClass('is-valid').addClass('is-invalid').parents('.form-group').append("<small class='form-text form-error'><%= message %></small>")
<% end %>
<% end %> 
<% else %>
$('#requests').replaceWith("<%= j render 'sparc_requests/table', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests %>")
initializeSelectpickers()
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>
