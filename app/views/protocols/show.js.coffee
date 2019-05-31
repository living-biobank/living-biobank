<% if @error %>
$('#sparc_request_protocol_attributes_research_master_id').addClass('is-invalid').after("<small class='form-text form-error'><%= @error %></small>")
<% else %>
$("[id^='sparc_request_'], [id=primary_pi_search]").removeClass('is-valid is-invalid')
$('.form-error, .form-alert').remove()
<% if @rmid_record %>
$('#sparc_request_protocol_attributes_title').val("<%= @rmid_record['long_title'] %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_short_title').val("<%= @rmid_record['short_title'] %>").prop('readonly', true)
<% else %>
$('#sparc_request_protocol_attributes_title').val("<%= @protocol.title %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_short_title').val("<%= @protocol.short_title %>").prop('readonly', true)
<% end %>
<% if @protocol %>
$('form#sparcRequestForm').append("<input type='hidden' id='sparc_request_protocol_id' name='sparc_request[protocol_id]' value='<%= @protocol.id %>' />")
$('form#sparcRequestForm').append("<input type='hidden' id='sparc_request_protocol_attributes_id' name='sparc_request[protocol_attributes][id]' value='<%= @protocol.id %>' />")
$('form#sparcRequestForm').append("<input type='hidden' id='sparc_request_protocol_attributes_primary_pi_role_attributes_id' name='sparc_request[protocol_attributes][primary_pi_role_attributes][id]' value='<%= @protocol.primary_pi_role.id %>' />")
$('#sparc_request_protocol_attributes_research_master_id').after("<span class='form-text text-success form-alert'>#{I18n.t('requests.form.subtext.protocol_found', {id: <%= @protocol.id %>})}</span>")
$('#sparc_request_protocol_attributes_type').prop('disabled', true)
$('#sparc_request_protocol_attributes_brief_description').val("<%= @protocol.brief_description %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_funding_status').selectpicker('val', "<%= @protocol.funding_status %>").siblings('.dropdown-toggle').prop('disabled', true)
$('#sparc_request_protocol_attributes_funding_source').selectpicker('val', "<%= @protocol.funding_source %>").siblings('.dropdown-toggle').prop('disabled', true)
$('#sparc_request_protocol_attributes_potential_funding_source').selectpicker('val', "<%= @protocol.potential_funding_source %>").siblings('.dropdown-toggle').prop('disabled', true)
$('.input-daterange.date').prop('readonly', true)
$('#sparc_request_protocol_attributes_start_date').datepicker('update', "<%= @protocol.start_date.strftime('%m/%d/%Y') %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_end_date').datepicker('update', "<%= @protocol.end_date.strftime('%m/%d/%Y') %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_end_date').datepicker('hide')
$('#primary_pi_search').val("<%= @protocol.primary_pi.display_name %>").prop('readonly', true)
$('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_id').val("<%= @protocol.primary_pi.id %>")
$('#primary_pi_search').typeahead('destroy')
<% else %>
$('#sparc_request_protocol_attributes_research_master_id').after("<span class='form-text text-warning form-alert'>#{I18n.t('requests.form.subtext.protocol_not_found')}</span>")
<% end %>
$('#sparc_request_protocol_attributes_end_date').blur()
<% end %>