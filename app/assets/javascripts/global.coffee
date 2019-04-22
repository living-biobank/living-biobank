$(document).on 'turbolinks:load', ->
  fixNavbarPlacement()
  fixHeaderPlacement()
  initializeSelectpickers()
  initializeTooltips()
  initializePopovers()
  $('html').addClass('ready')

$ ->
  $(window).resize ->
    fixNavbarPlacement()
    fixHeaderPlacement()

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
  if $('html').width() > 1199
    $('#content').css('margin-top', $('header').outerHeight())
    $('#content').css('margin-left', $('.navbar').outerWidth())
  else
    $('#content').css('margin-top', 0)
    $('#content').css('margin-left', 0)

(exports ? this).fixHeaderPlacement = () ->
  if $('html').width() > 1199
    $('header').css('margin-top', 0)
    $('header').css('margin-left', $('.navbar').outerWidth())
  else
    $('header').css('margin-top', $('.navbar').outerHeight())
    $('header').css('margin-left', 0)

(exports ? this).setRequiredFields = () ->
  $('.required:not(.has-indicator)').addClass('has-indicator').append('<span class="required-indicator">*</span>')

(exports ? this).initializeSelectpickers = () ->
  $('.selectpicker').selectpicker()

(exports ? this).initializeTooltips = () ->
  $('[data-toggle=tooltip]').tooltip()

(exports ? this).initializePopovers = () ->
  $('[data-toggle=popover]').popover()

(exports ? this).replaceUrl = (data) ->
  query_string = "?" + Object.keys(data).map((k) ->
    if data[k]
      k + '=' + data[k]
  ).filter((q) -> q).join("&")

  window.history.pushState({}, null, window.location.origin + window.location.pathname + query_string)
