<% if @errors %>
$("[id^='sparc_request_']").removeClass('is-invalid').addClass('is-valid')
$('.form-text').remove()
<% @fields = @errors.messages.keys %>
<% @errors.full_messages.each_with_index do |message, index| %>
$("#sparc_request_<%= @fields[index] %>").removeClass('is-valid').addClass('is-invalid').parents('.form-group').append("<small class='form-text form-error text-danger '><%= message %></small>")
<% end %>
<% else %>
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>
