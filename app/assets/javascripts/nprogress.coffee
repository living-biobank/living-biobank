NProgress.configure({ trickleRate: 0.025, trickleSpeed: 100 })

$(document).on('ajaxStart', ->
  NProgress.start()
).on('ajaxStop', ->
  NProgress.done()
)

$(document).on 'turbolinks:click', ->
  NProgress.start()

$(document).on 'turbolinks:render', ->
  NProgress.done()
