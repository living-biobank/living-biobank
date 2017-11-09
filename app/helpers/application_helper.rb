module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message
            end)
    end
    nil
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

