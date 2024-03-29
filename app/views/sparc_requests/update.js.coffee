<% if @errors %>
<% if @sparc_request.draft? %>
$("[id^='sparc_request_protocol_'], [id=primary_pi_search]").parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% else %>
$("[id^='sparc_request_'], [id=primary_pi_search]").parents('.form-group').removeClass('is-invalid').addClass('is-valid')
$('.form-error').remove()
<% end %>

# Data Request Consult Error
<% @errors[:dr_consult].each do |message| %>
$("#sparc_request_dr_consult").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>

# Protocol Errors
<% @sparc_request.protocol.errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$("#sparc_request_protocol_attributes_<%= attr.to_s %>").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>

# Primary PI Errors
<% if @sparc_request.protocol.primary_pi_role.errors.messages.any? %>
$('#pi-options').removeClass('is-valid').addClass('is-invalid')
if !($('#pi_automatic').hasClass('d-none'))
  $('#primary_pi_search').parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= I18n.t('activerecord.errors.models.sparc/project_role.attributes.identity.required').capitalize %></small>")
<% end %>

#Primary PI Identity Attributes Errors
<% @sparc_request.protocol.primary_pi_role.identity.errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
if !($('#pi_manual').hasClass('d-none'))
  $("#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_attributes_<%= attr.to_s %>").closest('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>

# Line Item Errors
<% @sparc_request.specimen_requests.each_with_index do |line_item, index| %>
<% line_item.errors.messages.each do |attr, messages| %>
<% messages.each do |message| %>
$(".nested_sparc_request_specimen_requests:visible:nth(<%= index %>) [name*='[<%= attr.to_s %>]']").parents('.form-group').removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% if attr == :query %>
$("#query-select-button-<%= index %>").removeClass('is-valid').addClass('is-invalid').append("<small class='form-text form-error'><%= message.capitalize %></small>")
<% end %>
<% end %>
<% end %>
<% end %>

$('#submitRequestButton, #saveDraftRequestButton').prop('disabled', false)

if $('.is-invalid').length
  $('html, body').animate({ scrollTop: $('.is-invalid').first().offset().top - $('header').height() - (parseInt($('#content').css('padding-top')) * 2) }, 'slow')
<% else %>
window.location.href = "<%= requests_path %>"
<% end %>

NProgress.done()
