module LabsHelper
  def lab_sort_filter_options(sort_by)
    sort_by ||= 'created_at'
    options_for_select(
      [:mrn, :samples_available, :specimen_source].map do |k|
        [t(:labs)[:fields][k], k]
      end, sort_by
    )
  end

  def lab_status_filter_options(status)
    options_for_select([
      [t('labs.filters.any_status'), '', selected: true],
      [t('labs.statuses.retrieved'), class: 'text-success'],
      [t('labs.statuses.released'), class: 'text-primary'],
      [t('labs.statuses.available'), class: 'text-warning'],
      [t('labs.statuses.discarded'), class: 'text-secondary']
    ], status)
  end

  def lab_source_filter_options(source)
    options_for_select(
      ([[t('labs.filters.any_source'), '', selected: true]] +
      (current_user.admin? ? Source.all : current_user.honest_brokeer.sources).map{ |source| [source.value, source.id] }), source)
  end

  def lab_patient_information(lab)
    icon('fas', 'user mr-2') +
    if lab.group.display_patient_information?
      t('labs.fields.sub_header_with_patient_name', id: lab.identifier, mrn: lab.mrn, lastname: lab.patient.lastname, firstname: lab.patient.firstname, dob: format_date(lab.dob))
    else
      t('labs.fields.sub_header_without_patient_name', id: lab.identifier, mrn: lab.mrn, dob: format_date(lab.dob))
    end
  end

  def lab_sample_size_display(line_item)
    text = line_item.number_of_specimens_requested == 1 ? 'singular' : 'plural'

    content_tag :p, class: 'mb-0' do
      icon('fas', 'flask mr-2') + t("labs.fields.samples_needed.#{text}", requested_number: line_item.number_of_specimens_requested, requested_size: line_item.minimum_sample_size).html_safe
    end
  end

  def lab_status_context(lab)
    klass =
      if lab.available?
        'badge-warning'
      else
        'badge-primary'
      end

    content_tag(:span, lab.status, class: ['badge p-2 ml-sm-2 mb-sm-0 lab-status', klass])
  end

  def lab_actions(lab)
    content_tag :div, class: 'mb-1' do
      raw([
        retrieve_lab_button(lab),
        cancel_lab_button(lab),
        discard_lab_button(lab)
      ].join(''))
    end
  end

  def release_lab_button(lab, line_item)
    content_tag :div, class: 'tooltip-wrapper', title: t(:labs)[:actions][:release_specimen], data: { toggle: 'tooltip' } do
      link_to lab_path(lab, lab: { status: I18n.t(:labs)[:statuses][:released], line_item_id: line_item.id, released_by: current_user.id}), remote: true, method: :patch, class: "btn btn-primary", data: { confirm_swal: 'true', title: t('labs.release_confirm.title', request: line_item.sparc_request.identifier), html: ' ' } do
        icon('fas', 'dolly')
      end
    end
  end

  def retrieve_lab_button(lab)
    link_to lab_path(lab, lab: { status: I18n.t(:labs)[:statuses][:retrieved] }), remote: true, method: :patch, class: "btn btn-success mr-1", title: t(:labs)[:actions][:retrieve_specimen], data: { toggle: "tooltip", confirm_swal: 'true', title: t('labs.retrieve_confirm.title') } do
      icon('fas', 'check-circle')
    end
  end

  def cancel_lab_button(lab)
    link_to lab_path(lab, lab: { status: I18n.t(:labs)[:statuses][:available], line_item_id: nil }), remote: true, method: :patch, class: "btn btn-warning mr-1", title: t(:labs)[:actions][:cancel_release], data: { toggle: "tooltip", confirm_swal: 'true', title: t('labs.cancel_confirm.title') } do
      icon('fas', 'redo')
    end
  end

  def discard_lab_button(lab)
    link_to lab_path(lab, lab: { status: I18n.t(:labs)[:statuses][:discarded] }), remote: true, method: :patch, class: "btn btn-danger", title: t(:labs)[:actions][:discard_specimen], data: { toggle: "tooltip", confirm_swal: 'true', title: t('labs.discard_confirm.title') } do
      icon('fas', 'trash-alt')
    end
  end
end
