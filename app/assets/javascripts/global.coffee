$(document).on 'turbolinks:load', ->
  fixNavbarPlacement()
  fixHeaderPlacement()
  initializeSelectpickers()
  initializeTooltips()
  $('html').addClass('ready')

$ ->
  $(document).on 'change keydown changed.bs.select changeDate', '.is-valid, .is-invalid', ->
    $(this).removeClass('is-valid is-invalid')
    $(this).parents('.form-group').children('.form-error').remove()

  $(document).on 'change', '.table-search', ->
    $container  = $(this).parents('.table-filters')
    data        = { term: $(this).val() }

    $container.find('select.filter-select').each (index, element) ->
      field = $(element).data('field')
      val   = $(element).val()
      if val != ""
        data[field] = val

    replaceUrl(data)

    $.ajax
      method: 'GET'
      dataType: 'script'
      url: $container.data('url')
      data: data

  $(document).on 'changed.bs.select', '.table-filters select.filter-select', ->
    $container  = $(this).parents('.table-filters')
    data        = { term: $container.find('.table-search').val() }

    $container.find('select.filter-select').each (index, element) ->
      field = $(element).data('field')
      val   = $(element).val()
      if val != ""
        data[field] = val

    replaceUrl(data)

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

(exports ? this).replaceUrl = (data) ->
  query_string = "?" + Object.keys(data).map((k) ->
    if data[k]
      k + '=' + data[k]
  ).filter((q) -> q).join("&")

  window.history.pushState({}, null, window.location.origin + window.location.pathname + query_string)
