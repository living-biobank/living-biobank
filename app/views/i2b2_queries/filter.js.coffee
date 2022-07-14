$('#query_select_pane').replaceWith("<%= j render 'query_select', musc_queries: @musc_queries, shrine_queries: @shrine_queries, musc_query_id: @musc_query_id, shrine_query_id: @shrine_query_id, specimen_option: @specimen_option, active_tab: @active_tab, protocol: @protocol, requester: @requester %>")
NProgress.done()
$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix