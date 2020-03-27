fillQueries = ->
  <% if @queries.any? %>
  options = []
  $("select[name*=query_name]").each ->
    if $(this).children().length == 1
      q = $(this).data('query-name')
      <% @queries.each do |query| %>
      selected = if q == "<%= query.name %>" then "selected=\"selected\"" else ""
      $(this).append($("<option value=\"<%= query.name %>\" #{selected}><%= query.name %></option>"))
      <% end %>

    $(this).selectpicker('refresh')
  <% else %>
  $("select[name*=query_name]").parents('.dropdown').attr('data-toggle', 'tooltip').prop('title', I18n.t('requests.form.tooltips.no_i2b2_queries'))
  <% end %>

fillQueries()

$(document).on 'fields_added.nested_form_fields', ->
  fillQueries()
