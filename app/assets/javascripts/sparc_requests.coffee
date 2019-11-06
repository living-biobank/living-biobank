$ ->
  rmidTimer = null

  $(document).on 'keyup', '#protocol_search', ->
    if !$(this).val()
      resetProtocolFields()

  $(document).on('mouseenter', '.specimen-line-item', ->
    _this = this
    $(this).popover('show')
    $('.popover').on 'mouseleave', ->
      $(_this).popover('hide')
  ).on('mouseleave', '.specimen-line-item', ->
    _this = this
    setTimeout( (->
      if !$('.popover:hover').length
        $(_this).popover('hide')
    ), 300)
  ).on('shown.bs.popover', '.specimen-line-item', (e) ->
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

  $(document).on('keyup', '#sparc_request_protocol_attributes_research_master_id:not([readonly=readonly])', ->
    clearTimeout(rmidTimer)
    if rmid = $(this).val()
      rmidTimer = setTimeout( (->
        $.ajax
          url: "/protocol"
          type: 'GET'
          dataType: 'script'
          data:
            rmid: rmid
      ), 500)
    else
      resetProtocolFields()
      initializePrimaryPITypeahead()
  ).on('keydown', '#sparc_request_protocol_attributes_research_master_id', ->
    clearTimeout(rmidTimer)
  )

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

(exports ? this).resetProtocolFields = () ->
  $("[id^='sparc_request_'], [id=primary_pi_search]").removeClass('is-valid is-invalid')
  $('.form-error, .form-alert').remove()
  $('#sparc_request_protocol_id').remove()
  $('#sparc_request_protocol_attributes_id').remove()
  $('#sparc_request_protocol_attributes_primary_pi_role_attributes_id').remove()
  $('#sparc_request_protocol_attributes_type').prop('disabled', false)
  $('#sparc_request_protocol_attributes_title').val('').prop('readonly', false)
  $('#sparc_request_protocol_attributes_short_title').val('').prop('readonly', false)
  $('#sparc_request_protocol_attributes_brief_description').val('').prop('readonly', false)
  $('#sparc_request_protocol_attributes_funding_status').selectpicker('val', '').siblings('.dropdown-toggle').prop('disabled', false)
  $('#sparc_request_protocol_attributes_funding_source').selectpicker('val', '').siblings('.dropdown-toggle').prop('disabled', false)
  $('#sparc_request_protocol_attributes_potential_funding_source').selectpicker('val', '').siblings('.dropdown-toggle').prop('disabled', false)
  $('#fundingSource').removeClass('d-none')
  $('#potentialFundingSource').addClass('d-none')
  $('#sparc_request_protocol_attributes_start_date').datepicker('update', '').prop('readonly', false)
  $('#sparc_request_protocol_attributes_end_date').datepicker('update', '').prop('readonly', false)
  $('#primary_pi_search').val('').prop('readonly', false)
  $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_id').val('')

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

  @updateVariables = ->
    source_ids = $(".source-select.selectpicker").map( ->
      $(this).selectpicker("val")).get()
    console.log source_ids
    $.ajax(
      url: "/update_valid_variables", 
      data: {sources: source_ids},
      success: showResponse = (data) ->
        console.log data
        options = ""

        $.each data['variables'], (index, value) ->
          options += "<option value='#{value['id']}'>#{value['name']}</option>"

        $('#sparc_request_variable_ids').html(options).selectpicker('refresh')
    );
