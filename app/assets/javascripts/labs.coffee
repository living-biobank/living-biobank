# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  ######################
  ### Specimens Page ###
  ######################

  $(window).on('popstate', ->
    query = window.location.search
    $('#specimen_report').attr('href', '/reports/specimen_report.csv' + query)
  )
