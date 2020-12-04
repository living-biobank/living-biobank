Swal.fire(
  title:              "<%= t('errors.internal_error.text1') %>"
  html:               "<%= t('errors.internal_error.text2', email: ENV.fetch('LBB_EMAIL')).html_safe %>"
  type:               'warning'
  confirmButtonClass: 'btn btn-lg btn-secondary'
  buttonsStyling:     false
)

$('button[type=submit').prop('disabled', false)
NProgress.done()
