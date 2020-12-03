$("[id^='sparc_request_'], [id=primary_pi_search]").parents('.form-group').removeClass('is-valid is-invalid')
$('.form-error, .form-alert').remove()

<% if @duplicate %>
Swal.fire(
  type: 'warning'
  title: "<%= t('requests.form.existing_request.title', status: @existing_request.human_status) %>"
  html: "<%= (@existing_request.in_process? ? t('requests.form.existing_request.in_process', status: @existing_request.human_status, email: ENV.fetch('LBB_EMAIL'), srid: @protocol.id, short_title: @protocol.short_title, lbb_id: @existing_request.identifier) : t('requests.form.existing_request.pending', status: @existing_request.human_status, srid: @protocol.id, short_title: @protocol.short_title, lbb_id: @existing_request.identifier)).html_safe %>"
  confirmButtonText: "<i class='fas fa-edit mr-1'></i>Edit Request"
  confirmButtonClass: 'btn btn-lg btn-warning mr-1'
  showConfirmButton: "<%= @existing_request.in_process? %>" == 'false'
  showCancelButton: true
  cancelButtonClass: 'btn btn-lg btn-secondary ml-1'
  buttonsStyling: false
).then (result) ->
  if result.value
    $.ajax
      method: 'GET'
      dataType: 'script'
      url: "<%= edit_sparc_request_path(@existing_request) %>"
<% elsif @rights %>
# Use the title/short title from SPARC
$('#sparc_request_protocol_attributes_title').val("<%= raw j @protocol.title %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_short_title').val("<%= raw j @protocol.short_title %>").prop('readonly', true)

# Pull remaining fields form SPARC
$('#sparc_request_protocol_id').val("<%= @protocol.id %>")
$('#sparc_request_protocol_attributes_id').val("<%= @protocol.id %>")
$('#sparc_request_protocol_attributes_selected_for_epic').val("<%= @protocol.selected_for_epic? %>")
$('#sparc_request_protocol_attributes_research_master_id').parents('.form-group').addClass('persist-validation is-valid').append("<small class='form-text text-success form-alert'>#{I18n.t('requests.form.subtext.protocol_found', {id: <%= @protocol.id %>})}</small>")
$('#sparc_request_protocol_attributes_funding_status').selectpicker('val', "<%= @protocol.funding_status %>").siblings('.dropdown-toggle').prop('disabled', true)
$('#sparc_request_protocol_attributes_sponsor_name').val("<%= raw j @protocol.sponsor_name %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_research_types_info_attributes_id').val("<%= @protocol.research_types_info.id %>").prop('readonly', true)

<% if @protocol.funded? %>
$('#sparc_request_protocol_attributes_funding_source').selectpicker('val', "<%= @protocol.funding_source %>").siblings('.dropdown-toggle').prop('disabled', true).parents('.form-group').removeClass('d-none')
$('#sparc_request_protocol_attributes_potential_funding_source').selectpicker('val', '').parents('.form-group').addClass('d-none')
<% else %>
$('#sparc_request_protocol_attributes_funding_source').selectpicker('val', '').parents('.form-group').addClass('d-none')
$('#sparc_request_protocol_attributes_potential_funding_source').selectpicker('val', "<%= @protocol.potential_funding_source %>").siblings('.dropdown-toggle').prop('disabled', true).parents('.form-group').removeClass('d-none')
<% end %>

<% if @protocol.start_date %>
$('#sparc_request_protocol_attributes_start_date').datepicker('update', "<%= @protocol.start_date.strftime('%m/%d/%Y') %>").prop('readonly', true)
<% else %>
$('#sparc_request_protocol_attributes_start_date').prop('readonly', false)
<% end %>

<% if @protocol.end_date %>
$('#sparc_request_protocol_attributes_end_date').datepicker('update', "<%= @protocol.end_date.strftime('%m/%d/%Y') %>").prop('readonly', true)
<% else %>
$('#sparc_request_protocol_attributes_end_date').prop('readonly', false)
<% end %>

$('#sparc_request_protocol_attributes_end_date').datepicker('hide')
$('#primary_pi_search').val("<%= @protocol.primary_pi.display_name %>").prop('readonly', true).typeahead('destroy')
$('#sparc_request_protocol_attributes_primary_pi_role_attributes_id').val("<%= @protocol.primary_pi_role.id %>")
$('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_id').val("<%= @protocol.primary_pi_role.identity_id %>")

# For some reason the RMID field is triggering the handler to remove contextual classes so we
# add the persist-validation class and then remove it here
$('#sparc_request_protocol_attributes_research_master_id').parents('.form-group').removeClass('persist-validation')
$('#sparc_request_protocol_attributes_research_master_id').focus()

loadI2B2Queries()
<% else %>
SweetAlert.fire(
  type: 'error'
  title: I18n.t('requests.form.alerts.permissions.title')
  html: I18n.t('requests.form.alerts.permissions.body', identifier: "<%= @protocol.identifier %>", pi_name: "<%= @protocol.primary_pi.full_name %>", pi_email: "<%= @protocol.primary_pi.email %>")
)
<% end %>
