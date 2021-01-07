$ ->
  if $('#groupDetailsForm').length
    $(document).on 'change', '#group_process_specimen_retrieval', ->
      $('#discardEmailContainer').toggleClass('d-none')

  $(document).on 'reorder-row.bs.table', '#servicesTable', (event, data, row, oldPosRow) ->
    $.ajax
      type: 'PUT'
      dataType: 'script'
      url: "/groups/#{row.group_id}/services/#{row.id}"
      data:
        service:
          position: oldPosRow.position


(exports ? this).initializeHonestBrokerTypeahead = () ->
  $("#honestBrokerSearch").typeahead('destroy')

  users = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: "/users/search?term=%TERM"
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

(exports ? this).initializeServiceTypeahead = () ->
  $("#service_search").typeahead('destroy')

  services = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: "/services/search?term=%TERM"
      wildcard: "%TERM"
  )

  services.initialize()

  $("#service_search").typeahead({
    minLength: 3
    hint: false
    highlight: true
  }, {
    displayKey: 'name'
    source: services.ttAdapter()
    limit: 100
    templates:
      empty: "<div class=\"tt-no-results\">#{I18n.t('constants')['no_records']}</div>"
      suggestion: (s) -> "
        <div class='tt-suggestion' data-toggle='#{if s.description then 'popover' else ''}' data-title='#{s.name}' data-content='#{escapeHTML(s.description)}' data-boundary='window' data-placement='right' data-trigger='hover' data-html='true'>
          <div class='w-100'>
            <h5 class='mb-0'><span class='text-service'>#{I18n.t('activerecord.models.sparc/service.one')}: </span>#{s.name}</h5>
          </div>
          <div class='w-100'>#{s.breadcrumb}</div>
          <div class='w-100'>
            <span><strong>#{I18n.t('activerecord.attributes.sparc/service.abbreviation')}: </strong>#{s.abbreviation}</span>
          </div>
          #{s.cpt_code_text}
        </div>
      "
  }).on 'typeahead:select', (event, suggestion) ->
    $('#service_sparc_id').val(suggestion.id)
