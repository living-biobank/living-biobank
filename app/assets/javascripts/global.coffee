$ ->
  fixNavbarPlacement()
  fixHeaderPlacement()
  initializeSelectpickers()
  initializeTooltips()
  initializePopovers()
  $('html').addClass('ready')

  $(document).on 'ajax:complete', ->
    initializeSelectpickers()
    initializeTooltips()
    initializePopovers()

  $(window).resize ->
    fixNavbarPlacement()
    fixHeaderPlacement()

  $(document).on 'show.bs.collapse hide.bs.collapse', 'div[data-toggle=collapse] + .collapse', (event) ->
    if event.delegateTarget.activeElement.tagName == 'A'
      event.preventDefault()

  $(document).on('mouseover', 'div[data-toggle=collapse]', (event) ->
    if ['A', 'BUTTON'].includes(event.target.tagName) || (event.target.tagName == 'I' && ['A', 'BUTTON'].includes(event.target.parentElement.tagName))
      $(this).removeClass('hover')
    else
      $(this).addClass('hover')
  ).on('mouseleave', 'div[data-toggle=collapse]', (event) ->
    $(this).removeClass('hover')
  ).on('mousedown', 'div[data-toggle=collapse]', (event) ->
    if event.target.tagName == 'DIV'
      $(this).addClass('active')
  ).on('mouseup', 'div[data-toggle=collapse]', (event) ->
    if event.target.tagName == 'DIV'
      $(this).removeClass('active')
  )

  $(document).on 'click', 'button[data-url]:not([data-confirm-swal]), a[href="javascript:void(0)"]:not([data-confirm-swal])', ->
    if $(this).data('url')
      $.ajax
        method: $(this).data('method') || 'get'
        dataType: 'script'
        url: $(this).data('url')
        data:
          authenticity_token: $('meta[name=csrf-token]').attr('content')

  $(document).on 'change keydown changed.bs.select changeDate', '.is-valid, .is-invalid', ->
    $(this).removeClass('is-valid is-invalid')
    $(this).parents('.form-group').children('.form-error').remove()

  searchTimer = null

  $(document).on('keyup', '.table-search', ->
    term = $(this).val()
    clearTimeout(searchTimer)
    searchTimer = setTimeout( (->
      $container  = $(this).parents('.table-filters')
      data        = { term: term }

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
    ), 500)
  ).on('keydown', '.table-search', ->
    clearTimeout(searchTimer)
  )

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

  $(document).on 'mouseup', (e) ->
    target = $(e.target)
    if target[0].className.indexOf('popover') == -1 && (target.data('toggle') != 'popover' || (target.data('toggle') == 'popover' && target.data('trigger').indexOf('click') == -1))
      $('.popover').popover('hide')

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
  $('.tooltip').tooltip('hide')
  $('[data-toggle=tooltip]').tooltip()

(exports ? this).initializePopovers = () ->
  $('[data-toggle=popover]').popover()

(exports ? this).replaceUrl = (data) ->
  query_string = "?" + Object.keys(data).map((k) ->
    if data[k]
      k + '=' + data[k]
  ).filter((q) -> q).join("&")

  window.history.pushState({}, null, window.location.origin + window.location.pathname + query_string)
