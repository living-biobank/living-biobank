$('#specimens').replaceWith("<%= j render 'labs/display', labs: @labs %>")

$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix
