$(document).on 'turbolinks:load', ->
  fixNavbarPlacement()
  fixHeaderPlacement()
  initializeSelectpickers()
  $('html').addClass('ready')

$ ->
  initializeTooltips()

  $(document).on 'change keydown changed.bs.select changeDate', '.is-valid, .is-invalid', ->
    $(this).removeClass('is-valid is-invalid')
    $(this).parents('.form-group').children('.form-error').remove()

  $(document).on 'changed.bs.select', '.table-filters select.filter-select', ->
    $container  = $(this).parents('.table-filters')
    data        = {}

    $container.find('select.filter-select').each (index, element) ->
      field = $(element).data('field')
      val   = $(element).val()
      if val != ""
        data[field] = val

    $.ajax
      method: 'GET'
      dataType: 'script'
      url: $container.data('url')
      data: data

(exports ? this).fixNavbarPlacement = () ->
  if $('html').width() > 1200
    $('#content').css('margin-top', $('header').outerHeight())
    $('#content').css('margin-left', $('.navbar').outerWidth())

(exports ? this).fixHeaderPlacement = () ->
  if $('html').width() > 1200
    $('header').css('margin-left', $('.navbar').outerWidth())
  else
    $('header').css('margin-top', $('.navbar').outerHeight())

(exports ? this).setRequiredFields = () ->
  $('.required').append('<span>*</span>')

(exports ? this).initializeSelectpickers = () ->
  $('.selectpicker').selectpicker()

(exports ? this).initializeTooltips = () ->
  $('[data-toggle=tooltip]').tooltip()
