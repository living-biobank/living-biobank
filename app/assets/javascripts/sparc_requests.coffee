$ ->
  #####################
  ### Requests Page ###
  #####################

  $(document).on('shown.bs.popover', '.specimen-line-item', (e) ->
    lineItem = $(e.target)

    if lineItem.data('one-yr') || lineItem.data('six-mo') || lineItem.data('three-mo')
      data = [
        [I18n.t('activerecord.attributes.line_item.one_year_accrual'), lineItem.data('one-yr')],
        [I18n.t('activerecord.attributes.line_item.six_month_accrual'), lineItem.data('six-mo')],
        [I18n.t('activerecord.attributes.line_item.three_month_accrual'), lineItem.data('three-mo')]
      ]
    else
      data = []
    new Chartkick['BarChart'](lineItem.data('chart-id'), data,
      {
        curve: false,
        messages: {
          empty: I18n.t('requests.table.specimens.chart.no_data')
        },
        library: {
          layout: {
            padding: {
              right: 125
            }
          }
          plugins: {
            datalabels: {
              anchor: 'end',
              align: 'right',
              formatter: (value, context) ->
                if context.dataIndex == 0
                  rate = value / 52 # 52 weeks/yr
                else if context.dataIndex == 1
                  rate = value / 26 # 4.33 weeks/mo * 6mo
                else if context.dataIndex == 2
                  rate = value / 13 # 4.33 weeks/mo * 3mo
                return I18n.t('requests.table.specimens.chart.value', value: value, rate: rate.toFixed(2))
            }
          }
        }
      }
    )
  )

  #####################
  ### Requests Form 3##
  #####################

  rmidTimer = null

  $(document).on('keyup', '#sparc_request_protocol_attributes_research_master_id:not([readonly=readonly])', ->
    clearTimeout(rmidTimer)
    if rmid = $(this).val()
      rmidTimer = setTimeout( (->
        $.ajax(
          url: "/protocol"
          type: 'GET'
          dataType: 'script'
          data:
            rmid: rmid
          success: (data, event, xhr) ->
            if xhr.status == 202
              data = $.parseJSON(data)
              $.ajax
                type: 'GET'
                dataType: 'script'
                url: if $('#sparc_request_id').val() then "/sparc_requests/#{$('#sparc_request_id').val()}/edit" else '/sparc_requests/new'
                success: ->
                  $('.form-error, .form-alert').remove()
                  $('#sparc_request_protocol_attributes_research_master_id').val(rmid).parents('.form-group').addClass('is-valid').append("<small class='form-text text-warning form-alert'>#{I18n.t('requests.form.subtext.protocol_not_found')}</small>")
                  $('#sparc_request_protocol_attributes_research_master_id').focus()
                  $('#sparc_request_protocol_attributes_title').val(data.title).prop('readonly', true)
                  $('#sparc_request_protocol_attributes_short_title').val(data.short_title).prop('readonly', true)
                  $('#primary_pi_search').val(data.primary_pi.display_name).prop('readonly', true).typeahead('destroy')
                  $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_id').val(data.primary_pi.id)
                  $('#sparc_request_protocol_attributes_title, #sparc_request_protocol_attributes_short_title, #primary_pi_search').parents('.form-group').append("<small class='form-text text-success'>#{I18n.t('requests.form.subtext.imported_from_rmid')}</small>")
          error: (xhr) ->
            message = $.parseJSON(xhr.responseText).error
            $('.form-error, .form-alert').remove()
            $.ajax
              type: 'GET'
              dataType: 'script'
              url: if $('#sparc_request_id').val() then "/sparc_requests/#{$('#sparc_request_id').val()}/edit" else '/sparc_requests/new'
              success: ->
                $('#sparc_request_protocol_attributes_research_master_id').focus()
                $('#sparc_request_protocol_attributes_research_master_id').val(rmid).parents('.form-group').addClass('is-invalid').append("<small class='form-text form-error'>#{message}</small>")
        )
      ), 750)
    else
      $.ajax
        type: 'GET'
        dataType: 'script'
        url: if $('#sparc_request_id').val() then "/sparc_requests/#{$('#sparc_request_id').val()}/edit" else '/sparc_requests/new'
        success: ->
          $('#sparc_request_protocol_attributes_research_master_id').focus()
  ).on('keydown', '#sparc_request_protocol_attributes_research_master_id', ->
    clearTimeout(rmidTimer)
  )

  $(document).on 'keyup', '#protocol_search', ->
    if !$(this).val()
      $.ajax
        type: 'GET'
        dataType: 'script'
        url: if $('#sparc_request_id').val() then "/sparc_requests/#{$('#sparc_request_id').val()}/edit" else '/sparc_requests/new'
        success: ->
          $('#sparc_request_protocol_attributes_research_master_id').focus()

  funding_source = null
  potential_funding_source = null

  $(document).on 'change', '#sparc_request_protocol_attributes_funding_status', ->
    if $(this).val() == 'funded'
      potential_funding_source = $('#sparc_request_protocol_attributes_potential_funding_source').val()
      $('#fundingSource').removeClass('d-none')
      $('#potentialFundingSource').addClass('d-none')
      $('#sparc_request_protocol_attributes_funding_source').selectpicker('val', funding_source)
      $('#sparc_request_protocol_attributes_potential_funding_source').selectpicker('val', '')
    else if $(this).val() == 'pending_funding'
      funding_source = $('#sparc_request_protocol_attributes_funding_source').val()
      $('#fundingSource').addClass('d-none')
      $('#potentialFundingSource').removeClass('d-none')
      $('#sparc_request_protocol_attributes_funding_source').selectpicker('val', '')
      $('#sparc_request_protocol_attributes_potential_funding_source').selectpicker('val', potential_funding_source)

  $(document).on 'change', '#sparc_request_protocol_attributes_start_date', ->
    if $(this).val()
      $(this).datepicker('hide')
      $('#sparc_request_protocol_attributes_end_date').focus()

  $(document).on 'changed.bs.select', '.source-select', ->
    $minSampleContainer = $(this).parents('.form-group').siblings('.min-sample-size-container')
    if $(this).find('option:selected').data('validates-sample-size') == true
      $minSampleContainer.removeClass('d-none')
    else
      $minSampleContainer.addClass('d-none')
      $minSampleContainer.find('input').val('')

  $(document).on 'click', '#saveDraftRequestButton', ->
    $('#sparc_request_status').remove()
    $form = $('form#sparcRequestForm')
    $form.append("<input name='save_draft' type='hidden' value='true' />")
    Rails.fire($form[0], 'submit')
    $("[name='save_draft']").remove()

  $.rails = {
    allowAction: ($el) ->
      return true
  }

  $(document).on 'fields_added.nested_form_fields', (event, param) ->
    if $('.nested_sparc_request_specimen_requests:visible').length > 0
      $('#sparcRequestForm input[type=submit], #saveDraftRequestButton').prop('disabled', false)
    setRequiredFields()
    initializeSelectpickers()
    initializeTooltips()

  $(document).on 'fields_removed.nested_form_fields', (event, param) ->
    if $('.nested_sparc_request_specimen_requests:visible').length == 0
      $('#sparcRequestForm input[type=submit], #saveDraftRequestButton').prop('disabled', true)
    $('.tooltip').tooltip('hide')

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

  $(document).on 'keydown', '.numerical:not(.decimal)', ->
    val = $(this).val()
    key = event.keyCode || event.charCode

    if !(nonCharacterKeys.includes(key) || numericalKeys.includes(key))
      event.preventDefault()

  $(document).on 'keydown', '.numerical.decimal', ->
    val = $(this).val()
    key = event.keyCode || event.charCode

    if !(nonCharacterKeys.includes(key) || numericalKeys.includes(key) || decimalKeys.includes(key))
      event.preventDefault()
    else if decimalKeys.includes(key) && val.includes('.')
      event.preventDefault()

(exports ? this).initializeProtocolTypeahead = () ->
  protocols = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: "/protocols?term=%TERM"
      wildcard: "%TERM"
  )

  protocols.initialize()

  $('#protocol_search').typeahead({
    minLength: 3
    hint: false
    highlight: true
  }, {
    displayKey: 'label'
    source: protocols.ttAdapter()
    limit: 100
    templates:
      empty: "<div class=\"tt-no-results\">#{I18n.t('constants')['no_records']}</div>"
  }).on 'typeahead:select', (event, suggestion) ->
    $.ajax
      url: "/protocol"
      type: 'GET'
      dataType: 'script'
      data:
        id: suggestion.id

(exports ? this).initializePrimaryPITypeahead = () ->
  $("#primary_pi_search:not([readonly=readonly])").typeahead('destroy')

  identities = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: "/directory/index?term=%TERM"
      wildcard: "%TERM"
  )

  identities.initialize()

  $("#primary_pi_search:not([readonly=readonly])").typeahead({
    minLength: 3
    hint: false
    highlight: true
  }, {
    displayKey: 'label'
    source: identities.ttAdapter()
    limit: 100
    templates:
      empty: "<div class=\"tt-no-results\">#{I18n.t('constants')['no_records']}</div>"
  }).on 'typeahead:select', (event, suggestion) ->
    $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_id').val(suggestion.id)

(exports ? this).loadI2B2Queries = () ->
  $.ajax
    meethod: 'GET'
    dataType: 'script'
    url: '/query_names'
    data:
      user_id: $('#sparc_request_user_id').val()
      request_id: $('#sparc_request_id').val()
