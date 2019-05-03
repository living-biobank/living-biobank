$ ->
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

  $(document).on 'click', '#saveDraftRequestButton', ->
    $.ajax
      method: 'POST'
      dataType: 'script'
      url: "/sparc_requests?#{$('form#new_sparc_request').serialize()}"
      data:
        authenticity_token: $('meta[name=csrf-token]').attr('content')
        save_draft:         'true'

  $.rails = {
    allowAction: ($el) ->
      return true
  }

  $(document).on 'fields_added.nested_form_fields', (event, param) ->
    setRequiredFields()
    initializeSelectpickers()
    initializeTooltips()

  $(document).on 'fields_removed.nested_form_fields', (event, param) ->
    $('.tooltip').tooltip('hide')

(exports ? this).initializePrimaryPITypeahead = () ->
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
