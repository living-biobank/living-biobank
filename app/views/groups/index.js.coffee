$('#groupsTable').replaceWith("<%= j render 'groups/table' %>")
$('.pagination').replaceWith("<%= j render 'layouts/pagination', records: @groups, filter_params: group_filter_params.merge({ controller: 'groups', action: 'index' }) %>")
