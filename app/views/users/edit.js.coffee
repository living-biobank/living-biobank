$('#modalContainer').html("<%= j render 'users/form', user: @user %>")
$('#modalContainer').modal('show')

<% if current_user.admin && current_user.id == @user.id %>
$('#user_admin').change ->
  if $(this).prop('checked') == false
    $(this).parents('.form-group').append("<small id='adminWarning' class='form-text text-danger mx-1 px-2'><i class='fas fa-exclamation-triangle mr-1'></i>#{I18n.t('users.form.admin_warning')}</small>")
  else
    $('#adminWarning').remove()
<% end %>
