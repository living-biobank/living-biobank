module LabsHelper
  def lab_sort_filter_options(sort_by)
    options_for_select(
      [:mrn, :samples_available, :specimen_source].map do |k|
        [t(:labs)[:fields][k], k]
      end, sort_by
    )
  end

  def accession_numbers(labs)
    raw(labs.map do |lab|
      content_tag(:span, lab.accession_number, class: 'w-100')
    end.join(', '))
  end

  def protocols_preview(protocols)
    if protocols.any?
      raw(protocols.map do |protocol|
        sr = protocol.sparc_request

        content = "
          <div class='d-flex flex-column'>
            <span class='d-flex justify-content-between mb-2'>#{sr.description}</span>
            <span class='d-flex justify-content-between mb-2'><strong class='mr-2'>#{t(:requests)[:fields][:specimens_requested]}: </strong>#{sr.number_of_specimens_requested}</span>
            <span class='d-flex justify-content-between'><strong class='mr-2'>#{t(:requests)[:fields][:minimum_sample]}: </strong>#{sr.minimum_sample_size}</span>
          </div>
        "

        link_to protocol.id, 'javascript:void(0)', data: { toggle: 'popover', trigger: 'hover', title: sr.title, content: content, html: true, placement: 'left' }
      end.join(', '))
    end
  end

  def release_lab_button(patient)
    link_to new_specimen_record_path(patient_id: patient.id), remote: true, title: t(:labs)[:tooltips][:release], class: 'btn btn-primary', data: { toggle: 'tooltip' } do
      raw(t(:actions)[:release] + icon('fas', 'share ml-1'))
    end
  end
end
