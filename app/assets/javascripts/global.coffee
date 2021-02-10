# Provide the CSRF Authenticity Token for all Ajax requests
$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});

$.fn.datepicker.defaults.clearBtn = true

$ ->
  $('html').addClass('ready')
  setRequiredFields()
  initializeSelectpickers()
  initializeTables()
  initializeTooltips()
  initializePopovers()
  initializeToggles()

  $(document).on 'ajaxComplete ajax:complete', ->
    setRequiredFields()
    initializeSelectpickers()
    initializeTables()
    initializeTooltips()
    initializePopovers()
    initializeToggles()

  # Add browser confirms when navigating away from forms with changes
  $('form').areYouSure()

  $(document).on 'ajax:beforeSend', 'form', ->
    id = $(this).prop('id')
    $(this).find('input[type=submit], button[type=submit]').prop('disabled', true)
    $("input[type=submit][form=#{id}], button[type=submit][form=#{id}]").prop('disabled', true)
    NProgress.start()

  # Remove form validation contexts when changing fields
  $(document).on 'keydown change change.datetimepicker', '.is-valid:not(.persist-validation), .is-invalid:not(.persist-validation)', ->
    $(this).removeClass('is-valid is-invalid').find('.form-error').remove()

  # Code to make nicer collapses with interactable interior content
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

  # Slight modifications to popover functionality
  $(document).on('mouseenter', '[data-toggle=popover][data-trigger=manual]', ->
    _this = this
    $(this).popover('show')
    $('.popover').on 'mouseleave', ->
      $(_this).popover('hide')
  ).on('mouseleave', '[data-toggle=popover]', ->
    _this = this
    setTimeout( (->
      if !$('.popover:hover').length
        $(_this).popover('hide')
    ), 500)
  )

  $(document).on 'mouseup', (e) ->
    target = $(e.target)
    if target[0].className.indexOf('popover') == -1 && (target.data('toggle') != 'popover' || (target.data('toggle') == 'popover' && target.data('trigger').indexOf('click') == -1))
      $('.popover').popover('hide')

  # Send Ajax requests for data-url buttons and links
  $(document).on 'click', 'button[data-url]:not([data-confirm-swal]), a[href="javascript:void(0)"]:not([data-confirm-swal])', ->
    if $(this).data('url')
      $.ajax
        method: $(this).data('method') || 'get'
        dataType: 'script'
        url: $(this).data('url')
        data:
          authenticity_token: $('meta[name=csrf-token]').attr('content')

  # Update records when using search
  searchTimer = null
  $(document).on('keyup', '.table-search', ->
    $this = $(this)
    term = $(this).val()
    clearTimeout(searchTimer)
    searchTimer = setTimeout( (->
      $container  = $this.parents('.table-filters')
      data        = { term: term }
      url         = new URL(window.location)

      url.searchParams.delete('term')
      url.searchParams.delete('page')
      $container.find('select.filter-select').each (index, element) ->
        field = $(element).data('field')
        val   = $(element).val()
        if val != ""
          data[field] = val
        url.searchParams.delete(field)

      url.searchParams.forEach (value, key) ->
        data[key] = value

      replaceUrl(data)

      NProgress.start()
      $.ajax
        method: 'GET'
        dataType: 'script'
        url: $container.data('url')
        data: data
        success: ->
          NProgress.done()
    ), 750)
  ).on('keydown', '.table-search', ->
    clearTimeout(searchTimer)
  )

  # Update records when using filters
  $(document).on 'changeDate.datepicker changed.bs.select', '.table-filters .filter-date, .table-filters select.filter-select', ->
    $container  = $(this).parents('.table-filters')
    data        = { term: $container.find('.table-search').val() }

    $container.find('.filter-date input, select.filter-select').each (index, element) ->
      field = $(element).data('field')
      val   = $(element).val()
      if val != ""
        data[field] = val

    replaceUrl(data)

    NProgress.start()
    $.ajax
      method: 'GET'
      dataType: 'script'
      url: $container.data('url')
      data: data
      success: ->
        NProgress.done()

(exports ? this).setRequiredFields = () ->
  $('.required:not(.has-indicator)').addClass('has-indicator').append('<span class="required-indicator">*</span>')

(exports ? this).initializeSelectpickers = () ->
  $('.selectpicker').selectpicker()

(exports ? this).initializeTables = () ->
  $('[data-toggle=table]').bootstrapTable()

(exports ? this).initializeTooltips = () ->
  $('.tooltip').tooltip('hide')
  $('[data-toggle=tooltip]').tooltip()

(exports ? this).initializePopovers = () ->
  $('[data-toggle=popover]').popover()

(exports ? this).initializeToggles = () ->
  $('input[data-toggle=toggle]').each ->
    if !$(this).data('bs.toggle')
      $(this).bootstrapToggle()

(exports ? this).replaceUrl = (data) ->
  query_string = "?" + Object.keys(data).map((k) ->
    if data[k]
      k + '=' + data[k]
  ).filter((q) -> q).join("&")

  window.history.pushState({}, null, window.location.origin + window.location.pathname + query_string)

(exports ? this).escapeHTML = (text) ->
  if text
    return text.replace(/&/g,'&amp;' ).replace(/</g,'&lt;').
      replace(/"/g,'&quot;').replace(/'/g,'&#039;')
  else
    return text

nonCharacterKeys = [
  8, 9, 16, 17, # delete, tab, shift, ctrl
  37,38,39,40   # arrow keys
]
numericalKeys = [
  48, 49, 50, 51, 52, 53, 54, 55, 56, 57,       # 0-9
  96, 97, 98, 99, 100, 101, 102, 103, 104, 105  # 0-9 Num Pad
]

decimalKeys = [
  110, 190 # period keys
]

$(document).on 'paste', '.numerical', ->
  return false

$(document).on 'drop', '.numerical', ->
  return false

$(document).on 'keydown', '.numerical:not(.decimal)', ->
  val = $(this).val()
  key = event.keyCode || event.charCode

  if !(nonCharacterKeys.includes(key) || (numericalKeys.includes(key) && !event.shiftKey))
    event.preventDefault()

$(document).on 'keydown', '.numerical.decimal', ->
  val           = $(this).val()
  key           = event.keyCode || event.charCode
  decimalIndex  = val.indexOf('.')

  # Prevent non-numerical characters/utility key presses
  if !(nonCharacterKeys.includes(key) || ((numericalKeys.includes(key) || decimalKeys.includes(key)) && !event.shiftKey))
    event.preventDefault()
  # Prevent duplicate decimal characters
  else if event.shiftKey || (decimalKeys.includes(key) && decimalIndex >= 0)
    event.preventDefault()
  # Limit the input to two decimal places
  else if event.shiftKey || (numericalKeys.includes(key) && decimalIndex >= 0 && decimalIndex < val.length - 2 && this.selectionStart > decimalIndex)
    event.preventDefault()

    