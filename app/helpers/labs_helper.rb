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

  def lab_status_context(lab)
    klass =
      if lab.available?
        'badge-warning'
      else
        'badge-primary'
      end

    content_tag(:span, lab.status, class: ['badge h3 p-2 mb-sm-0 lab-status', klass])
  end
end
