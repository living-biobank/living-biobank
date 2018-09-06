# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#quick_scan").click().focus()

  wto = null

  $("#quick_scan").change ->
    match = false

    clearTimeout(wto)
    wto = setTimeout ->
      term = $("#quick_scan").val()
      $(".lab-records table tr").each (index, row) ->
        td_val = $(row).find("td").eq(0).text()

        if !match and (td_val == term)
          match = true
          $("#match").show()
          $("#match").fadeOut(3000)

      $("#quick_scan").val("")

    , 1000

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
