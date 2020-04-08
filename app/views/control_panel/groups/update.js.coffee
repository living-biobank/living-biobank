<% if @errors %>
$("[id^='group_']").parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()

<% @errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$("#group_<%= attr.to_s %>").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>
<% else %>
$('#groupsTable').bootstrapTable('refresh')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#modalContainer').modal('hide')
<% end %>
