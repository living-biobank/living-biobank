
<% if @musc_query.present? %>
$("#query-select-button-<%= @specimen_option%>").removeClass('is-invalid')
$("#query-select-button-<%= @specimen_option%> .form-error").remove()
$("#specimen_options_<%= @specimen_option %> .combined_query_select").text("<%= @musc_query.name %>")
$("#specimen_options_<%= @specimen_option %> #sparc_request_specimen_requests_attributes_<%= @specimen_option %>_query_id").val("<%= @musc_query.id %>")
$("#specimen_options_<%= @specimen_option %> #sparc_request_specimen_requests_attributes_<%= @specimen_option %>_act_query_id").val("")
<% end %>

<% if @shrine_query.present? %>
$("#query-select-button-<%= @specimen_option %>").removeClass('is-invalid')
$("#query-select-button-<%= @specimen_option %> .form-error").remove()
$("#specimen_options_<%= @specimen_option %> .combined_query_select").text("<%= @shrine_query.query_name %>")
$("#specimen_options_<%= @specimen_option %> #sparc_request_specimen_requests_attributes_<%= @specimen_option %>_act_query_id").val("<%= @shrine_query.id %>")
$("#specimen_options_<%= @specimen_option %> #sparc_request_specimen_requests_attributes_<%= @specimen_option %>_query_id").val("")
<% end %>

$('#modalContainer').modal('hide')
NProgress.done()