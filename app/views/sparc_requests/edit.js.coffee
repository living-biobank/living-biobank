# Only used for redirecting from a new request with duplicate RMID
# to an existing request

$('#sparcRequestForm').removeClass('dirty');
window.history.pushState({}, null, "<%= new_request_url %>")
window.location.href = "<%= edit_request_path(@sparc_request) %>"
