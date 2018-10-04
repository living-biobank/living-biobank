<% if @errors %>
$("[id^='specimen_record_']").removeClass('is-invalid').addClass('is-valid')
$('.dropdown-toggle').removeClass('border-danger').addClass('border-success')
$('.form-error').remove()
<% @fields = @errors.messages.keys %>
<% @errors.full_messages.each_with_index do |message, index| %>
if $("#specimen_record_<%= @fields[index] %>").hasClass('selectpicker')
  $("#specimen_record_<%= @fields[index] %> + .dropdown-toggle").removeClass('border-success').addClass('border-danger')  
else
  $("#specimen_record_<%= @fields[index] %>").removeClass('is-valid').addClass('is-invalid')
$("#specimen_record_<%= @fields[index] %>").parents('.form-group').append("<small class='form-text form-error'><%= message %></small>")
<% end %>
<% else %>
$('#labs').replaceWith("<%= j render 'labs/table', lab_groups: @lab_groups %>")
$('#modalContainer').modal('hide')
$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
<% end %>
