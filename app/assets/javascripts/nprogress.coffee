NProgress.configure({ trickleRate: 0.025, trickleSpeed: 100 })

$(document).on('ajaxSend ajax:send', ->
  NProgress.start()
).on('ajaxComplete ajax:complete', ->
  NProgress.done()
)
