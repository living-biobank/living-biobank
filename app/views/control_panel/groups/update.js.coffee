<% if @errors %>
$("[id^='group_']").parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()

<% @errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$("#group_<%= attr.to_s %>").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>
<% else %>
$('#groupManagement').replaceWith("<%= j render 'control_panel/groups/groups_panel', groups: @groups %>")
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#modalContainer').modal('hide')
<% end %>
