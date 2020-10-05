$('#modalContainer').html("<%= j render 'control_panel/sources/form', source: @source, group: @group, groups_source_name: nil%>")
$('#modalContainer').modal('show')

