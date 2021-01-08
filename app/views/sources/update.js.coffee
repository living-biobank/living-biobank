<% if @errors %>
$('#key #value').parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% @errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$("#<%= attr %>").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>
$('button[type=submit], input[type=submit]').prop('disabled', false)
<% else %>
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#groupSources').load(location.href + " #groupSources")
<% end %>
NProgress.done()
