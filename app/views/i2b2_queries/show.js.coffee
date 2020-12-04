$(".i2b2-query[data-query-id=<%= @query.query_master_id %>]").replaceWith("<%= j controller.helpers.query_display(@query) %>")
