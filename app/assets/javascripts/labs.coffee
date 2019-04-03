# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#verifySpecimens').val('')
  $('#verifySpecimens').focus()

  $(document).on 'change', '#verifySpecimens', ->
    mrn = $(this).val()

    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/labs'
      success: (data) ->
        type = if data.map((el) -> el.mrn).includes(mrn) then 'success' else 'error'

        $('tr').removeClass('alert-success')
        if type == 'success'
          console.log $("td:textEquals(#{mrn})")
          $("td:textEquals(#{mrn})").parent().addClass('alert-success')

        swal({
          type: type
          title: if type == 'success' then I18n.t('labs.search.found') else I18n.t('labs.search.not_found')
          showConfirmButton: false
          timer: 1000
          width: "20rem"
        }).then ->
          $('#verifySpecimens').val('')
          $('#verifySpecimens').focus()

$.expr[':'].textEquals = $.expr.createPseudo((arg) ->
  return (elem) ->
    return $(elem).text().match("^" + arg + "$")
)
