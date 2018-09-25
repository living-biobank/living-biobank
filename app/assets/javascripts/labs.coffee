# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#verifySpecimens').val('')
  $('#verifySpecimens').focus()

  $(document).on 'change', '#verifySpecimens', ->
    $this = $(this)

    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/labs'
      success: (data) ->
        type = if data.map((el) -> el.mrn).includes($this.val()) then 'success' else 'error'

        swal({
          type: type
          showConfirmButton: false
          timer: 1000
          width: "20rem"
        }).then ->
          $('#verifySpecimens').val('')
          $('#verifySpecimens').focus()
