<% if @errors %>
$("[id^='specimen_record_']").removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% @errors.keys.each do |attr| %>
<% @errors.full_messages_for(attr).each do |message| %>
$("#specimen_record_<%= attr.to_s %>").removeClass('is-valid').addClass('is-invalid').parents('.form-group').append("<small class='form-text form-error'><%= message %></small>")
<% end %>
<% end %>
<% else %>
$('#labs').replaceWith("<%= j render 'labs/table', lab_groups: @lab_groups %>")
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>
