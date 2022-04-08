# i2b2 queries javascripts

$(document).on 'mouseup', '.musc-query-option', ->
  if $(this).hasClass('active')
    $(this).removeClass('active')
    $('#musc_query').val('')
  else  
    $(this).siblings().removeClass('active')
    $(this).addClass('active')
    $('#musc_query').val($(this).attr('musc_query_id'))

# $(document).on 'mouseup', '#i2b2_select_submit', ->
#   musc_id = $('.musc-query-option.active').attr('musc_query_id')