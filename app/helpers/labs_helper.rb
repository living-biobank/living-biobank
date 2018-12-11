module LabsHelper
  def lab_sort_filter_options(sort_by)
    options_for_select(
      [:mrn, :samples_available, :specimen_source].map do |k|
        [t(:labs)[:fields][k], k]
      end, sort_by
    )
  end

  def protocols_preview(protocols)
    if protocols.any?
      protocols.map do |protocol|
        sr = protocol.sparc_request

        tooltip = "
          <span class='float-left text-left w-100 mb-2'><strong>#{sr.title}</strong></span>
          <span class='float-left text-left w-100 mb-2'>#{sr.description}</span>
          <span class='float-left text-left w-100 mb-2'><strong>#{t(:requests)[:fields][:specimens_requested]}: </strong>#{sr.number_of_specimens_requested}</span>
          <span class='float-left text-left w-100'><strong>#{t(:requests)[:fields][:minimum_sample]}: </strong>#{sr.minimum_sample_size}</span>
          <div class='clearfix'></div>
        "

        link_to protocol.id, 'javascript:void(0)', data: { toggle: 'tooltip', title: tooltip, html: true, placement: 'left' }
      end.join(', ')
    else
      'N/A'
    end
  end

  def release_lab_button(patient)
    link_to t(:actions)[:release], new_specimen_record_path(patient_id: patient.id), remote: true, class: 'btn btn-primary'
  end
end
