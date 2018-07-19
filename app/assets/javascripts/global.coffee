$ ->

$(document).on 'turbolinks:load', ->
  $('#content').css('margin-top', $('nav.navbar').outerHeight())
  $('html').addClass('ready')
