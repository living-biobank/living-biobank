$('#flashContainer').html("<%= j render 'layouts/flash', flash: flash %>")
$('#specimenFilters').replaceWith("<%= j render 'labs/filters' %>")
$('#specimens').replaceWith("<%= j render 'labs/display', labs: @labs %>")

$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
