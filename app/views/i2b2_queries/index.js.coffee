updateQueries = () ->
  <% if @queries.any? %>
  $("select[name*=query_id]").parents('.dropdown').tooltip('dispose')
  options = []
  $("select[name*=query_id]").each ->
    $(this).children('option:not(:first-child):not(:selected)').remove()
    val = $(this).val()
    <% @queries.each do |query| %>
    if val != "<%= query.id %>"
      $(this).append($("<option value=\"<%= query.id %>\"><%= query.name %></option>"))
    <% end %>
  <% else %>
  $("select[name*=query_id]").parents('.dropdown').data('toggle', 'tooltip').prop('title', "<%= t("requests.form.tooltips.no_i2b2_queries.#{params[:protocol_id].present? ? 'protocol' : 'user'}").html_safe %>").tooltip('dispose').tooltip()
  <% end %>

updateQueries()
$("select[name*=query_id]").selectpicker('refresh')

$(document).off('fields_added.nested_form_fields').on('fields_added.nested_form_fields', ->
  $("select[name*=query_id]").one 'rendered.bs.select', ->
    updateQueries()
  $(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
)
