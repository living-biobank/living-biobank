$ ->
  $(document).on 'change', '#group_process_specimen_retrieval', ->
    $('#discardEmailContainer').toggleClass('d-none')

(exports ? this).initializeHonestBrokerTypeahead = () ->
  $("#honestBrokerSearch").typeahead('destroy')

  users = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: "/control_panel/users/search?term=%TERM"
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
