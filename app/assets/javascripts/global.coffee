$(document).on 'turbolinks:load', ->
  if $('html').width() > 1200
    $('header').css('margin-left', $('.navbar').outerWidth())
    $('#content').css('margin-top', $('header').outerHeight())
    $('#content').css('margin-left', $('.navbar').outerWidth())
  else
    $('header').css('margin-top', $('.navbar').outerHeight())

  $('html').addClass('ready')

$ ->
  initializeTooltips()

  $(document).on 'change keydown changed.bs.select changeDate', '.is-valid, .is-invalid', ->
    $(this).removeClass('is-valid is-invalid')
    $(this).parents('.form-group').children('.form-error').remove()

(exports ? this).dateSorter = (a, b) ->
  if !a && !b
    return 0
  else if a && !b
    return 1
  else if !a && b
    return -1
  else
    sort_a = new Date(a)
    sort_b = new Date(b)
    return 1 if sort_a > sort_b
    return -1 if sort_a < sort_b
    return 0

(exports ? this).setRequiredFields = () ->
  $('.required').append('<span>*</span>')

(exports ? this).initializeSelectpickers = () ->
  $('.selectpicker').selectpicker()

(exports ? this).initializeTooltips = () ->
  $('[data-toggle=tooltip]').tooltip()
