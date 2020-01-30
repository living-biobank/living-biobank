<% if @error %>
$('#sparc_request_protocol_attributes_research_master_id').parents('.form-group').addClass('is-invalid').after("<small class='form-text form-error'><%= @error %></small>")
<% else %>
$("[id^='sparc_request_'], [id=primary_pi_search]").removeClass('is-valid is-invalid')
$('.form-error, .form-alert').remove()

<% if @protocol %>

<% if @rmid_record %>
# Use the title/short title from RMID
$('#sparc_request_protocol_attributes_title').val("<%= @rmid_record['long_title'] %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_short_title').val("<%= @rmid_record['short_title'] %>").prop('readonly', true)
<% else %>
# Use the title/short title from SPARC
$('#sparc_request_protocol_attributes_title').val("<%= @protocol.title %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_short_title').val("<%= @protocol.short_title %>").prop('readonly', true)
<% end %>

# Pull remaining fields form SPARC
$('#sparc_request_protocol_id').val("<%= @protocol.id %>")
$('#sparc_request_protocol_attributes_id').val("<%= @protocol.id %>")
$('#sparc_request_protocol_attributes_research_master_id').parents('.form-group').addClass('persist-validation is-valid').append("<span class='form-text text-success form-alert'>#{I18n.t('requests.form.subtext.protocol_found', {id: <%= @protocol.id %>})}</span>")
$('#sparc_request_protocol_attributes_type').prop('disabled', true)
$('#sparc_request_protocol_attributes_brief_description').val("<%= @protocol.brief_description %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_funding_status').selectpicker('val', "<%= @protocol.funding_status %>").siblings('.dropdown-toggle').prop('disabled', true)

<% if @protocol.funded? %>
$('#sparc_request_protocol_attributes_funding_source').selectpicker('val', "<%= @protocol.funding_source %>").siblings('.dropdown-toggle').prop('disabled', true).parents('.form-group').removeClass('d-none')
$('#sparc_request_protocol_attributes_potential_funding_source').selectpicker('val', '').parents('.form-group').addClass('d-none')
<% else %>
$('#sparc_request_protocol_attributes_funding_source').selectpicker('val', '').parents('.form-group').addClass('d-none')
$('#sparc_request_protocol_attributes_potential_funding_source').selectpicker('val', "<%= @protocol.potential_funding_source %>").siblings('.dropdown-toggle').prop('disabled', true).parents('.form-group').removeClass('d-none')
<% end %>

<% if @protocol.start_date %>
$('#sparc_request_protocol_attributes_start_date').datepicker('update', "<%= @protocol.start_date.strftime('%m/%d/%Y') %>").prop('readonly', true)
<% end %>

<% if @protocol.end_date %>
$('#sparc_request_protocol_attributes_end_date').datepicker('update', "<%= @protocol.end_date.strftime('%m/%d/%Y') %>").prop('readonly', true)
<% end %>

$('#sparc_request_protocol_attributes_end_date').datepicker('hide')
$('#primary_pi_search').val("<%= @protocol.primary_pi.display_name %>").prop('readonly', true).typeahead('destroy')
$('#sparc_request_protocol_attributes_primary_pi_role_attributes_id').val("<%= @protocol.primary_pi_role.id %>")
$('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_id').val("<%= @protocol.primary_pi_role.identity_id %>")

# For some reason the RMID field is triggering the handler to remove contextual classes so we
# add the persist-validation class and then remove it here
$('#sparc_request_protocol_attributes_research_master_id').parents('.form-group').removeClass('persist-validation')
$('#sparc_request_protocol_attributes_research_master_id').focus()
<% else %>
$.ajax
  type: 'GET'
  dataType: 'script'
  url: "/sparc_requests/#{$('#sparc_request_id').val()}/edit"
  success: ->
    $('#sparc_request_protocol_attributes_research_master_id').val("<%= @rmid_record['id'] %>").parents('.form-group').addClass('is-valid').append("<span class='form-text text-warning form-alert'>#{I18n.t('requests.form.subtext.protocol_not_found')}</span>")
    $('#sparc_request_protocol_attributes_research_master_id').focus()
    $('#sparc_request_protocol_attributes_title').val("<%= @rmid_record['long_title'] %>").prop('readonly', true)
    $('#sparc_request_protocol_attributes_short_title').val("<%= @rmid_record['short_title'] %>").prop('readonly', true)
<% end %>
<% end %>
