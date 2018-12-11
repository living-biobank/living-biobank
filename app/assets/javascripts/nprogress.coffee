$ ->
  $(document).ajaxStart( ->
    NProgress.start()
  ).ajaxStop( ->
    NProgress.done()
  )

  $(document).on 'turbolinks:click', -> 
    NProgress.start()

  $(document).on 'turbolinks:render', ->
    NProgress.done()
