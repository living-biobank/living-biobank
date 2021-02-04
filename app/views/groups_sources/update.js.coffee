<% if @errors %>
$("[id^='groups_source_']").parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% @errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$("#groups_source_<%= attr.to_s %>").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>

<% @groups_source.source.errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$("#groups_source_source_attributes_<%= attr.to_s %>").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>

$('button[type=submit], input[type=submit]').prop('disabled', false)
<% else %>
$('#groupsSourcesTable').bootstrapTable('refresh')
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>

NProgress.done()
