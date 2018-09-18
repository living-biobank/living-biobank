// This file has to be required before rails-ujs
// To use it change `data-confirm` of your links to `data-confirm-swal`
(function() {
  const handleConfirm = function(element) {
    if (!allowAction(this)) {
      Rails.stopEverything(element)
    }
  }

  const allowAction = element => {
    if (element.getAttribute('data-confirm-swal') === null) {
      return true
    }

    showConfirmationDialog(element)
    return false
  }

  // Display the confirmation dialog
  const showConfirmationDialog = element => {
    const title = element.getAttribute('data-title');
    const html = element.getAttribute('data-html');
    const confirm_text = element.getAttribute('data-confirm-text');
    const cancel_text = element.getAttribute('data-cancel-text');

    swal({
      title: title || I18n.t('confirm.title'),
      html: html || I18n.t('confirm.text'),
      type: 'warning',
      showCancelButton: true,
      confirmButtonText: confirm_text || I18n.t('confirm.confirm'),
      confirmButtonClass: 'btn btn-lg btn-primary mr-1',
      cancelButtonText: cancel_text || I18n.t('confirm.cancel'),
      cancelButtonClass: 'btn btn-lg btn-secondary ml-1',
      buttonsStyling: false
    }).then(result => confirmed(element, result))
  }

  const confirmed = (element, result) => {
    if (result.value) {
      // User clicked confirm button
      $.ajax({
        method: 'GET',
        url: element.getAttribute('href'),
        dataType: element.getAttribute('data-remote') === 'true' ? 'script' : 'html'
      });
    }
  }

  // Hook the event before the other rails events so it works togeter
  // with `method: :delete`.
  // See https://github.com/rails/rails/blob/master/actionview/app/assets/javascripts/rails-ujs/start.coffee#L69
  document.addEventListener('rails:attachBindings', element => {
    Rails.delegate(document, 'a[data-confirm-swal]', 'click', handleConfirm)
  })

}).call(this)
