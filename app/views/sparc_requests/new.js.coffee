$('#modalContainer').html("<%= j render 'sparc_requests/form', sparc_request: @sparc_request %>")
setRequiredFields()

# specimen source typeahead search, preventing user entry
$.get "/specimen_source.json", (data) ->
  $("#sparc_request_service_source").typeahead
    source: data
,'json'

# pi name search
$("#sparc_request_primary_pi_name").typeahead(
  source: (term, process) ->
    $.get "/directory/search.json?term=#{term}", (data) ->
      process(data.results)
  templates:
    notFound: ->
      return "<span>Not Found</span>"
  display: 'name'
)

$('#modalContainer').modal('show')
