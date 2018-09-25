# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'click', '#saveDraftRequestButton', ->
    serialized_params = $('form#new_sparc_request').serialize()

    $.ajax
      method: 'POST'
      dataType: 'script'
      url: "/sparc_requests?#{$('form#new_sparc_request').serialize()}"
      data:
        authenticity_token: $('meta[name=csrf-token]').attr('content')
        save_draft:         'true'
