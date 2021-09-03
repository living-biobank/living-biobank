updateQueries = () ->
  <% if @musc_queries.any? %>
  $("select[name*=query_id]").parents('.dropdown').tooltip('dispose')
  options = []
  $("select[name*=query_id]").each ->
    $(this).children('option:not(:first-child):not(:selected)').remove()
    val = $(this).val()
    <% @musc_queries.each do |query| %>
    if val != "<%= query.id %>"
      $(this).append($("<option value=\"<%= query.id %>\"><%= query.name %></option>"))
    <% end %>
  $(".musc-dropdown").removeAttr('hidden')
  <% else %>
  $("select[name*=query_id]").parents('.dropdown').data('toggle', 'tooltip').prop('title', "<%= t("requests.form.tooltips.no_i2b2_queries.#{params[:protocol_id].present? ? 'protocol' : 'user'}").html_safe %>").tooltip('dispose').tooltip()
  <% end %>

  <% if @shrine_queries.any? %>
  $("select[name*=act_query_id]").parents('.dropdown').tooltip('dispose')
  options = []
  $("select[name*=act_query_id]").each ->
    $(this).children('option:not(:first-child):not(:selected)').remove()
    val = $(this).val()
    <% @shrine_queries.each do |query| %>
    if val != "<%= query.id %>"
      $(this).append($("<option value=\"<%= query.id %>\"><%= query.query_name %></option>"))
    <% end %>
  $(".shrine-dropdown").removeAttr('hidden')

  <% else %>
  $("select[name*=act_query_id]").parents('.dropdown').data('toggle', 'tooltip').prop('title', "<%= t("requests.form.tooltips.no_i2b2_queries.#{params[:protocol_id].present? ? 'protocol' : 'user'}").html_safe %>").tooltip('dispose').tooltip()
  <% end %>

  $(".loading-spinner").attr('hidden', true)

updateQueries()
$("select[name*=query_id]").selectpicker('refresh')
$("select[name*=act_query_id]").selectpicker('refresh')


$(document).off('fields_added.nested_form_fields').on('fields_added.nested_form_fields', ->
  $(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
  updateQueries()
  $("select[name*=query_id]").selectpicker('refresh')
)
