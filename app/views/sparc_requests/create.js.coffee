<% if @errors %>
$("[id^='sparc_request_']").removeClass('is-invalid').addClass('is-valid')
$('.form-text').remove()
<% @fields = @errors.messages.keys %>
<% @errors.full_messages.each_with_index do |message, index| %>
$("#sparc_request_<%= @fields[index] %>").removeClass('is-valid').addClass('is-invalid')
if $("#sparc_request_<%= @fields[index] %>").parent().hasClass('input-group')
  $("#sparc_request_<%= @fields[index] %>").parent().after("<small class='form-text text-danger'><%= message %></small>")
else
  $("#sparc_request_<%= @fields[index] %>").after("<small class='form-text text-danger'><%= message %></small>")
<% end %>
<% else %>
$('#modalContainer').modal('close')
$('#requestsTable').bootstrapTable('refresh')
<% end %>
