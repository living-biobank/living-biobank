$('subheader').replaceWith("<%= j render 'control_panel/groups/subheader', group: @group %>")
$('#groupSection').replaceWith('<%= j render "control_panel/groups/#{params[:tab] || 'details'}", group: @group %>')
$(document).trigger('ajax:complete') # rails-ujs element replacement bug fix

window.history.pushState({}, null, "<%= edit_control_panel_group_path(@group, tab: params[:tab] || 'details') %>")
