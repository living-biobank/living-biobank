# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # specimen source typeahead search, preventing user entry
  $.get "/specimen_source.json", (data) ->
    $("#service_source_typeahead .typeahead").typeahead
      source: data
  ,'json'

  # pi name search
  $("#pi_search_typeahead .typeahead").typeahead
    source: (query, process) ->
      $.get "/directory/search.json?query=#{query}", (data) ->
        process(data.results)
    display: 'name'

  # date pickers
  $('.date-select').datepicker(autoclose: true)

