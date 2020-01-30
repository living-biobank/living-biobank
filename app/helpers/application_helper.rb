module ApplicationHelper
  def errors_controller?
    controller_name == 'errors'
  end

  def bootstrap_alert(type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.stringify_keys[type.to_s]
  end

  def format_date(date)
    date.strftime("%m/%d/%Y") if date
  end

  def protocol_preview protocol
    sr = protocol.sparc_request
    title = "<div class='protocol-preview'>"
    title += "<label>Title</label><br /> #{sr.title}"
    title += "<br /><br />"
    title += "<label>Description</label><br /> #{sr.description}"
    title += "<br /><br />"
    title += "<label># of Samples Requested</label><br /> #{sr.number_of_specimens_requested}"
    title += "<br /><br />"
    title += "<label>Minimum Sample Size</label><br /> #{sr.minimum_sample_size}"
    title += "</div>"
    content_tag :button, protocol.id, type: 'button', class: 'btn btn-secondary', data: { toggle: 'tooltip', title: title, html: true, placement: 'left' }
  end
end

