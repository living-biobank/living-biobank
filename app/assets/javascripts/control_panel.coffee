$ ->
  $(document).on('change', '#groupDetailsForm input:not([type=text])', ->
    $('#saveGroupDetailsBtn').removeClass('d-none')
  ).on('keydown', '#groupDetailsForm input[type=text]', ->
    $('#saveGroupDetailsBtn').removeClass('d-none')
  ).on('trix-change', '#groupDetailsForm trix-editor', ->
    $('#saveGroupDetailsBtn').removeClass('d-none')
  )

(exports ? this).initializeHonestBrokerTypeahead = () ->
  $("#honestBrokerSearch").typeahead('destroy')

  users = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: "/directory/index?term=%TERM"
      wildcard: "%TERM"
  )

  users.initialize()

  $("#honestBrokerSearch").typeahead({
    minLength: 3
    hint: false
    highlight: true
  }, {
    displayKey: 'label'
    source: users.ttAdapter()
    limit: 100
    templates:
      empty: "<div class=\"tt-no-results\">#{I18n.t('constants')['no_records']}</div>"
  }).on 'typeahead:select', (event, suggestion) ->
    $('#lab_honest_broker_user_id').val(suggestion.id)
