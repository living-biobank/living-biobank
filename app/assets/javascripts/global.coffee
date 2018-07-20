$ ->

$(document).on 'turbolinks:load', ->
  $('#content').css('margin-top', $('nav.navbar').outerHeight())
  $('html').addClass('ready')

  $('.bootstrap-table').bootstrapTable()

(exports ? this).dateSorter = (a, b) ->
  if !a && !b
    return 0
  else if a && !b
    return 1
  else if !a && b
    return -1
  else
    sort_a = new Date(a)
    sort_b = new Date(b)
    return 1 if sort_a > sort_b
    return -1 if sort_a < sort_b
    return 0

(exports ? this).setRequiredFields = () ->
  $('.required').append('<span>*</span>')
