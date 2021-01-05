$('#modalContainer').html("<%= j render 'sources/form', source: @source, group: @group, groups_source_name: nil, groups_source_description: nil%>")
$('#modalContainer').modal('show')

