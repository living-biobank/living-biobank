$('#modalContainer').html("<%= j render 'sources/form', source: @source, group: @group, groups_source: @groups_source, edit_form: false%>")
$('#modalContainer').modal('show')

