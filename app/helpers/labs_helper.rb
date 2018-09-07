module LabsHelper

  def protocols_preview(protocols)
    if protocols.any?
      protocols.map do |protocol|
        sr = protocol.sparc_request

        tooltip = "
          <span class='float-left text-left w-100 mb-2'><label class='m-0'>Title:</label><br>#{sr.title}</span>
          <span class='float-left text-left w-100 mb-2'><label class='m-0'>Description:</label><br>#{sr.description}</span>
          <span class='float-left text-left w-100 mb-2'><label class='m-0'># of Samples Requested:</label><br>#{sr.number_of_specimens_requested}</span>
          <span class='float-left text-left w-100'><label class='m-0'>Minimum Sample Size:</label><br>#{sr.minimum_sample_size}</span>
          <div class='clearfix'></div>
        "

        link_to protocol.id, 'javascript:void(0)', data: { toggle: 'tooltip', title: tooltip, html: true, placement: 'left' }
      end.join('')
    end
  end

  def release_lab_button(patient)
    link_to t(:actions)[:release], new_specimen_record_path(patient_id: patient.id), remote: true, class: 'btn btn-primary'
  end
end
