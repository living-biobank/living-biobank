# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'click', '#saveDraftRequestButton', ->
    serialized_params = $('form#new_sparc_request').serialize()

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
    initializeSelectpickers()

(exports ? this).initializePrimaryPITypeahead = () ->
  # pi name search
  $("#sparc_request_primary_pi_name").typeahead(
    source: (term, process) ->
      $.get "/directory/search.json?term=#{term}", (data) ->
        process(data.results)
    templates:
      notFound: ->
        return "<span>Not Found</span>"
    display: 'name'
    minLength: 3
    afterSelect: (suggestion) ->
      $('#sparc_request_primary_pi_netid').val(suggestion.netid)
      $('#sparc_request_primary_pi_email').val(suggestion.email)
  )
