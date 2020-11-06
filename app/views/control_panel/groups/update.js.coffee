<% if @errors %>
$("[id^='group_']").parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()

<% @errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$("#group_<%= attr.to_s %>").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>
<% else %>
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#saveGroupDetailsBtn').removeClass('show')
<% end %>
