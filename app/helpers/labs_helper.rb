module LabsHelper
  def lab_sort_filter_options(sort_by)
    options_for_select(
      [:mrn, :samples_available, :specimen_source].map do |k|
        [t(:labs)[:fields][k], k]
      end, sort_by
    )
  end

  def accession_numbers(labs)
    if labs.any?
      raw(labs.map do |lab|
        content_tag(:span, lab.accession_number, class: 'w-100')
      end.join(', '))
    end
  end

  def protocols_preview(patient, source)
    if patient.sparc_requests.any?
      content_tag :div, class: 'd-flex flex-column' do
        raw(patient.sparc_requests.in_process.map do |request|
          content = request.line_items.where(service_source: source).map do |line_item|
            content_tag :div, class: 'd-flex flex-column request-preview' do
              content_tag(:span, t('labs.requests.specimens_requested', amount_requested: line_item.number_of_specimens_requested, min_sample_size: line_item.minimum_sample_size)) +
              raw(render('line_items/progress_bar', li: line_item))
            end
          end.join('')

          content_tag :div do
            link_to request.identifier, 'javascript:void(0)', data: { toggle: 'popover', trigger: 'hover', title: request.identifier, content: content, html: true, placement: 'left' }
          end
        end.join(''))
      end
    end
  end
end
