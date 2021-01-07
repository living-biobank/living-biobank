<% if @errors %>
$('#honestBrokerSearch').parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% @errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$('#honestBrokerSearch').parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>
$('.form-submit').prop('disabled', false)
<% else %>
$('#honestBrokersTable').bootstrapTable('refresh')
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>

NProgress.done()
