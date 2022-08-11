# i2b2 queries javascripts

$(document).on 'mouseup', '.musc-query-option', ->
  if $(this).hasClass('active')
    $(this).removeClass('active')
    $('#musc_query').val('')
  else  
    $(this).siblings().removeClass('active')
    $(this).addClass('active')
    $('#musc_query').val($(this).attr('musc_query_id'))

$(document).on 'click', ".sort_radio_button, .query_search_button", ->
  filterQueries()

$(document).on 'click', ".clear_search_button", ->
  clearFilters()

$(document).on 'keypress', '.query-modal', ->
  if event.keyCode == 13
    event.preventDefault()

$(document).on 'keyup', '.query_search', ->
  if event.keyCode == 13
    filterQueries()


(exports ? this).filterQueries = () ->  
  NProgress.start()

  user_id = $('#user_id').val()
  protocol_id = $('#protocol_id').val()
  specimen_option = $('#specimen_option').val()
  musc_query_id = $('#musc_query_id').val()
  shrine_query_id = $('#shrine_query_id').val()
  term = $('.query_search').val()
  sort_by = $("[name='sortRadio']:checked").attr('id').split('_')[0]
  sort_order = $("[name='sortRadio']:checked").attr('id').split('_')[1]
  active_tab = $("a[role='tab'].active").attr('id')

  $.ajax
      method: 'GET'
      dataType: 'script'
      url: '/i2b2_queries/filter'
      data:
        user_id:      user_id
        protocol_id:  protocol_id
        specimen_option: specimen_option
        musc_query_id: musc_query_id
        shrine_query_id: shrine_query_id
        term: term
        sort_by: sort_by
        sort_order: sort_order
        active_tab: active_tab


(exports ? this).clearFilters = () ->  
  NProgress.start()
  $('.query_search').val('')
  $('#date_asc').prop('checked', true)

  user_id = $('#user_id').val()
  protocol_id = $('#protocol_id').val()
  specimen_option = $('#specimen_option').val()
  musc_query_id = $('#musc_query_id').val()
  shrine_query_id = $('#shrine_query_id').val()
  term = ''
  sort_by = 'date'
  sort_order = 'asc'
  active_tab = $("a[role='tab'].active").attr('id')

  $.ajax
      method: 'GET'
      dataType: 'script'
      url: '/i2b2_queries/filter'
      data:
        user_id:      user_id
        protocol_id:  protocol_id
        specimen_option: specimen_option
        musc_query_id: musc_query_id
        shrine_query_id: shrine_query_id
        term: term
        sort_by: sort_by
        sort_order: sort_order
        active_tab: active_tab


