<% if @errors %>
$("[id^='sparc_request_']").removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% @fields = @errors.messages.keys %>
<% @errors.full_messages.each_with_index do |message, index| %>
$("#sparc_request_<%= @fields[index] %>").removeClass('is-valid').addClass('is-invalid').parents('.form-group').append("<small class='form-text form-error'><%= message %></small>")
<% end %>
<% else %>
$('#requests').replaceWith("<%= j render 'sparc_requests/table', requests: @requests %>")
$('#draftRequests').replaceWith("<%= j render 'sparc_requests/draft_requests', draft_requests: @draft_requests ")
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>
