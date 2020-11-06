$('#modalContainer').html("<%= j render 'control_panel/sources/edit_form', source: @source, group: @group, groups_source_name: @groups_source_name%>")
$('#modalContainer').modal('show')