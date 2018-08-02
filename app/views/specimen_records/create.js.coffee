<% if @errors %>
$("[id^='specimen_record_']").removeClass('is-invalid').addClass('is-valid')
$('.form-text').remove()
<% @fields = @errors.messages.keys %>
<% @errors.full_messages.each_with_index do |message, index| %>
$("#specimen_record_<%= @fields[index] %>").removeClass('is-valid').addClass('is-invalid')
if $("#specimen_record_<%= @fields[index] %>").parent().hasClass('input-group')
  $("#specimen_record_<%= @fields[index] %>").parent().after("<small class='form-text text-danger'><%= message %></small>")
else
  $("#specimen_record_<%= @fields[index] %>").after("<small class='form-text text-danger'><%= message %></small>")
<% end %>
<% else %>
$('#modalContainer').modal('close')
$('#labsTable').bootstrapTable('refresh')
<% end %>
