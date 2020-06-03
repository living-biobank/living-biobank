updateQueries = () ->
  <% if @queries.any? %>
  options = []
  $("select[name*=query_name]").each ->
    val = $(this).val()
    $(this).children('option:not(:first-child)').remove()
    <% @queries.each do |query| %>
    selected = if val == "<%= query.name.html_safe %>" then "selected=\"selected\"" else ""
    $(this).append($("<option value=\"<%= query.name %>\" #{selected}><%= query.name %></option>"))
    <% end %>

    $(this).selectpicker('refresh')
  <% else %>
  $("select[name*=query_name]").parents('.dropdown').attr('data-toggle', 'tooltip').prop('title', I18n.t('requests.form.tooltips.no_i2b2_queries'))
  <% end %>

updateQueries()

$(document).off('fields_added.nested_form_fields').on('fields_added.nested_form_fields', ->
  updateQueries()
  $(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
)
