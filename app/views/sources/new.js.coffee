$('#modalContainer').html("<%= j render 'sources/form', source: @source, group: @group, groups_source_name: nil%>")
$('#modalContainer').modal('show')

