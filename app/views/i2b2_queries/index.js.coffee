updateQueries = () ->
  <% if @queries.any? %>
  $("select[name*=query_id]").parents('.dropdown').prop('title', '').tooltip('show')
  options = []
  $("select[name*=query_id]").each ->
    val = $(this).val()
    # $(this).children('option:not(:first-child)').remove()
    <% @queries.each do |query| %>
    if val != "<%= query.id %>"
      $(this).append($("<option value=\"<%= query.id %>\"><%= query.name %></option>"))
    <% end %>

    $(this).selectpicker('refresh')
  <% else %>
  $("select[name*=query_id]").parents('.dropdown').attr('data-toggle', 'tooltip').prop('title', "<%= t("requests.form.tooltips.no_i2b2_queries.#{params[:protocol_id].present? ? 'protocol' : 'user'}").html_safe %>")
  $("select[name*=query_id] option:not(:first-child)").remove()
  $("select[name*=query_id]").selectpicker('refresh')
  <% end %>

updateQueries()

$(document).off('fields_added.nested_form_fields').on('fields_added.nested_form_fields', ->
  updateQueries()
  $(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
)
