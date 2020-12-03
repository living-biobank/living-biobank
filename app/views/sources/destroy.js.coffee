$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#groupSources').load(location.href + " #groupSources")