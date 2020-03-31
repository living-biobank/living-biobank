$('#modalContainer').html("<%= j render 'permissions/form', user: @user, groups: @groups %>")
$('#modalContainer').modal('show')

<% if current_user.admin && current_user.id == @user.id %>
$('#user_admin').change ->
  if $(this).is(':checked') == false
    $('.admin_selector').append("<small id='adminWarning' class='text-danger'><i class='fas fa-exclamation-triangle'></i> #{I18n.t('control_panel.user_management.change_permissions.admin_warning')}</small>")
  else
    $('#adminWarning').remove()
<% end %>



