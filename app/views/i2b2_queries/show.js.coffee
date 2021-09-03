<% if @musc_query.present? %>
$(".musc-query[data-query-id=<%= @musc_query.query_master_id %>]").replaceWith("<%= j controller.helpers.query_display(@musc_query, 'musc') %>")
<% elsif @shrine_query.present? %>
$(".act-query[data-query-id=<%= @shrine_query.id %>]").replaceWith("<%= j controller.helpers.query_display(@shrine_query, 'shrine') %>")
<% end %>