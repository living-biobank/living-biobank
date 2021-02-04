$('#modalContainer').html("<%= j render 'form', source: @source, group: @group, groups_source: @groups_source%>")
$('#modalContainer').modal('show')

