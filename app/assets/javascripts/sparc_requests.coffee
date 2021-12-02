$ ->
  #####################
  ### Requests Page ###
  #####################

  $(document).on('changed.bs.select', '.musc-query-select', (e) ->  
    if $(this).val() != ''
      $(this).parents('.form-group').siblings('.shrine-dropdown').find('select').val('').prop('disabled', true)
    else
      $(this).parents('.form-group').siblings('.shrine-dropdown').find('select').prop('disabled', false)

    $('.selectpicker').selectpicker('refresh')
    e.stopPropagation()
  )

  $(document).on('changed.bs.select', '.act-query-select', (e) ->  
    if $(this).val() != ''
      $(this).parents('.form-group').siblings('.musc-dropdown').find('select').prop('disabled', true)
    else
      $(this).parents('.form-group').siblings('.musc-dropdown').find('select').prop('disabled', false)

    $('.selectpicker').selectpicker('refresh')
    e.stopPropagation()
  )

  if $('.musc-query').length || $('.act-query').length
    loadI2B2Queries()

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

  if $('#sparcRequestForm').length
    loadI2B2Queries()
    initializeProtocolTypeahead()
    initializePrimaryPITypeahead()

    rmidTimer = null

    if !$('#sparc_request_id').val() && $('#internal_user').val() == 'true'
      $("[id^='sparc_request_protocol_']:not(#sparc_request_protocol_attributes_research_master_id), [id=primary_pi_search]").prop('readonly', true)
      $('#sparc_request_protocol_attributes_funding_status').prop('disabled', true).selectpicker('refresh')
      $('#sparc_request_protocol_attributes_funding_source').prop('disabled', true).selectpicker('refresh')
      $('#sparc_request_protocol_attributes_potential_funding_source').prop('disabled', true).selectpicker('refresh')

    $(document).on('keyup', '#sparc_request_protocol_attributes_research_master_id:not([readonly=readonly])', ->
      clearTimeout(rmidTimer)
      if rmid = $(this).val()
        rmidTimer = setTimeout ->
          NProgress.start()
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
                  complete: ->
                    NProgress.done()
                  success: ->
                    $('.form-error, .form-alert').remove()
                    $('#sparc_request_protocol_attributes_research_master_id').val(rmid).parents('.form-group').addClass('is-valid').append("<small class='form-text text-warning form-alert'>#{I18n.t('requests.form.subtext.protocol_not_found')}</small>")
                    $('#sparc_request_protocol_attributes_research_master_id').focus()
                    $('#sparc_request_protocol_attributes_title').val(data.title).prop('readonly', true)
                    $('#sparc_request_protocol_attributes_short_title').val(data.short_title).prop('readonly', true)
                    $('#primary_pi_search').val(data.primary_pi.display_name).prop('readonly', true).typeahead('destroy')
                    $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_id').val(data.primary_pi.id)
                    $('#sparc_request_protocol_attributes_title, #sparc_request_protocol_attributes_short_title, #primary_pi_search').parents('.form-group').append("<small class='form-text text-success'>#{I18n.t('requests.form.subtext.imported_from_rmid')}</small>")
              else
                NProgress.done()
            error: (xhr) ->
              message = $.parseJSON(xhr.responseText).error
              $('.form-error, .form-alert').remove()
              $.ajax
                type: 'GET'
                dataType: 'script'
                url: if $('#sparc_request_id').val() then "/sparc_requests/#{$('#sparc_request_id').val()}/edit" else '/sparc_requests/new'
                complete: ->
                  NProgress.done()
                success: ->
                  $('#sparc_request_protocol_attributes_research_master_id').focus()
                  $('#sparc_request_protocol_attributes_research_master_id').val(rmid).parents('.form-group').addClass('is-invalid').append("<small class='form-text form-error'>#{message}</small>")
          )
        , 750
      else
        NProgress.start()
        $.ajax
          type: 'GET'
          dataType: 'script'
          url: if $('#sparc_request_id').val() then "/sparc_requests/#{$('#sparc_request_id').val()}/edit" else '/sparc_requests/new'
          success: ->
            $('#sparc_request_protocol_attributes_research_master_id').focus()
            $("[id^='sparc_request_protocol_']:not(#sparc_request_protocol_attributes_research_master_id), [id=primary_pi_search]").prop('readonly', true)
            $('#sparc_request_protocol_attributes_funding_status').prop('disabled', true).selectpicker('refresh')
            $('#sparc_request_protocol_attributes_funding_source').prop('disabled', true).selectpicker('refresh')
            $('#sparc_request_protocol_attributes_potential_funding_source').prop('disabled', true).selectpicker('refresh')
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
      else
        funding_source = $('#sparc_request_protocol_attributes_funding_source').val()
        potential_funding_source = $('#sparc_request_protocol_attributes_potential_funding_source').val()
        $('#fundingSource').addClass('d-none')
        $('#potentialFundingSource').addClass('d-none')
        $('#sparc_request_protocol_attributes_funding_source').selectpicker('val', '')
        $('#sparc_request_protocol_attributes_potential_funding_source').selectpicker('val', '')

    $(document).on 'change', '#sparc_request_protocol_attributes_start_date', ->
      if $(this).val()
        $(this).datepicker('hide')
        $('#sparc_request_protocol_attributes_end_date').focus()

    $(document).on 'changed.bs.select', '.groups-source-select', ->
      $minSampleContainer = $(this).parents('.form-group').siblings('.min-sample-size-container')
      if $(this).find('option:selected').data('validates-sample-size') == true
        $minSampleContainer.removeClass('d-none')
      else
        $minSampleContainer.addClass('d-none')
        $minSampleContainer.find('input').val('')

    $(document).on 'click', '#saveDraftRequestButton', (event) ->
      $(this).prop('disabled', true)
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
      url: "/sparc/directory/index?term=%TERM"
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
    $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_attributes_first_name').val(suggestion.first_name)
    $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_attributes_first_name').attr('readonly', true)
    $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_attributes_last_name').val(suggestion.last_name)
    $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_attributes_last_name').attr('readonly', true)
    $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_attributes_email').val(suggestion.email)
    $('#sparc_request_protocol_attributes_primary_pi_role_attributes_identity_attributes_email').attr('readonly', true)

(exports ? this).loadI2B2Queries = () ->
  if $('.musc-query').length || $('.act-query').length
    
    # Get all unique MUSC query ids on the page, then send AJAX requests to populate them
    query_ids = $('.musc-query').map(->
      $(this).data('query-id')
    ).toArray().filter( (itm, i, arr) ->
      arr.indexOf(itm) == i
    ).forEach( (query_id) ->
      $.ajax
        method: 'GET'
        dataType: 'script'
        url: "/i2b2_queries/#{query_id}"
        data:
          query_type: 'musc'
    )

    # Get all unique ACT Shrine query ids on the page, then send AJAX requests to populate them
    query_ids = $('.act-query').map(->
      $(this).data('query-id')
    ).toArray().filter( (itm, i, arr) ->
      arr.indexOf(itm) == i
    ).forEach( (query_id) ->
      $.ajax
        method: 'GET'
        dataType: 'script'
        url: "/i2b2_queries/#{query_id}"
        data:
          query_type: 'shrine'
    )
  else
    $("select[name*=query_id]").parents('.dropdown').data('toggle', 'tooltip').prop('title', I18n.t('constants.loading')).tooltip()
    $.ajax
      method: 'GET'
      dataType: 'script'
      url: '/i2b2_queries'
      data:
        user_id:      $('#sparc_request_user_id').val()
        protocol_id:  $('#sparc_request_protocol_id').val()
      complete: ->
        $('.musc-query-select').each ->
          if $(this).val() != ''
            $(this).parents('.form-group').siblings('.shrine-dropdown').find('select').val('').prop('disabled', true)
        $('.act-query-select').each ->
          if $(this).val() != ''
            $(this).parents('.form-group').siblings('.musc-dropdown').find('select').val('').prop('disabled', true)
        $('.selectpicker').selectpicker('refresh')
        

  $(document).on 'mouseup', '#pi_radio1', ->
    $('#pi_automatic').removeClass('d-none')
    if (!$('#pi_manual').hasClass('d-none'))
      $('#pi_manual').addClass('d-none')
    

  $(document).on 'mouseup', '#pi_radio2', -> 
    $('#pi_manual').removeClass('d-none')
    if (!$('#pi_automatic').hasClass('d-none'))
      $('#pi_automatic').addClass('d-none')

  $(window).on('popstate', ->
    query = window.location.search
    $('#sparc_request_report').attr('href', '/reports/sparc_request_report.csv' + query)
  )



