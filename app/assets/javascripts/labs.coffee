# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  ######################
  ### Specimens Page ###
  ######################

  #NOTE:  The following code is a workaround for an issue with Google Chrome that causes it to give the csv reports the same file name, regardless of timestamp, if the download report button is clicked multiple times without changing the query string.
  $(document).on('click', '#specimen_report', (event) -> 

    query = window.location.search
    version = ''

    if query.length > 0
      version = '&version='
    else
      version = '?version='

    $('#specimen_report').attr('href', '/reports/specimen_report.csv' + query + version + Date.now())
    
    return true
  )