<% if @errors %>
$("[id^='group_']").parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()

<% @errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$("#group_<%= attr.to_s %>").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>

$('#saveGroupButton').prop('disabled', false)

if $('.is-invalid').length
  $('html, body').animate({ scrollTop: $('.is-invalid').first().offset().top - $('header').height() - $('subheader').height() - (parseInt($('#content').css('padding-top')) * 2) }, 'slow')
<% else %>
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
window.location.href = "<%= edit_group_path(@group, tab: 'users') %>"
<% end %>
