module LabsHelper
  def lab_sort_filter_options(sort_by)
    sort_by = sort_by.blank? ? 'id' : sort_by
    options_for_select(
      [:id, :specimen_source, :released_at, :accession_number, :status, :specimen_date].map do |k|
        [Lab.human_attribute_name(k), k]
      end.sort, sort_by
    )
  end

  def lab_sort_order_options(sort_order)
    sort_order = sort_order.blank? ? 'desc' : params[:sort_order]
    options_for_select(
      t(:constants)[:order].invert,
      sort_order
    )
  end

  def lab_status_filter_options(status)
    if current_user.admin? || current_user.groups.any?(&:process_specimen_retrieval?)
      status = status.blank? ? 'active' : status
      options_for_select([
        [t('labs.filters.all_status'),    'any'],
        [t('labs.filters.active_status'), 'active'],
        [t('labs.statuses.retrieved'),    'retrieved',  class: 'text-success'],
        [t('labs.statuses.released'),     'released',   class: 'text-primary'],
        [t('labs.statuses.available'),    'available',  class: 'text-warning'],
        [t('labs.statuses.discarded'),    'discarded',  class: 'text-secondary']
      ], status)
    else
      status = status.blank? ? 'any' : status
      options_for_select([
        [t('labs.filters.all_status'),  'any'],
        [t('labs.statuses.available'),  'available',  class: 'text-warning'],
        [t('labs.statuses.released'),   'released',   class: 'text-primary'],
        [t('labs.statuses.discarded'),  'discarded',  class: 'text-secondary']
      ], status)
    end
  end

  def lab_source_filter_options(source)
    source = source.blank? ? 'any' : source
    options_for_select(
      [[t('labs.filters.any_source'), 'any']] + (current_user.admin? ? Source.all : current_user.sources).map{ |source| [source.value, source.id] },
      source)
  end

  def lab_header_display(lab)
    content_tag(:span, t('labs.table.header', id: lab.identifier), class: 'mt-0 mt-sm-1 mr-2') +
    content_tag(:small, "#{lab.source.value} (#{lab.accession_number})", class: 'text-muted d-inline-flex align-items-center mt-0 mt-sm-1')
  end

  def lab_patient_information(lab)
    content_tag :span, class: 'text-muted' do
      t('labs.table.patient_info', id: lab.identifier, mrn: lab.mrn, lastname: lab.patient.lastname, firstname: lab.patient.firstname, dob: format_date(lab.dob), specimen_date: format_date(lab.specimen_date)).html_safe
    end
  end

  def lab_releaser_information(lab)
    name =
      link_to(lab.releaser.full_name, 'javascript:void(0)', class: 'd-none d-xl-inline-block', data: { toggle: 'popover', html: 'true', placement: 'left', container: 'body', trigger: 'manual', content: render('users/user_popover', user: lab.releaser) }) +
      link_to(lab.releaser.full_name, 'javascript:void(0)', class: 'd-inline-block d-xl-none', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: render('users/user_popover', user: lab.releaser) })

    content_tag :span, class: 'text-muted' do
      icon('fas', 'user mr-1') + t("labs.table.#{lab.releaser == current_user ? 'releaser_self' : 'releaser'}", name: name, date: format_date(lab.released_at)).html_safe
    end
  end

  def lab_retriever_information(lab)
    content_tag :span, class: 'text-success' do
      icon('fas', 'user mr-1') + t('labs.table.retriever', date: format_date(lab.retrieved_at)).html_safe
    end
  end

  def lab_discarder_information(lab)
    name =
      link_to(lab.discarder.full_name, 'javascript:void(0)', class: 'd-none d-xl-inline-block', data: { toggle: 'popover', html: 'true', placement: 'left', container: 'body', trigger: 'manual', content: render('users/user_popover', user: lab.discarder) }) +
      link_to(lab.discarder.full_name, 'javascript:void(0)', class: 'd-inline-block d-xl-none', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: render('users/user_popover', user: lab.discarder) })

    content_tag :span, class: 'text-danger' do
      icon('fas', 'user mr-1') + t("labs.table.#{lab.discarder == current_user ? 'discarder_self' : 'discarder'}", name: name, date: format_date(lab.discarded_at)).html_safe
    end
  end

  def lab_sample_size_display(line_item)
    text = line_item.number_of_specimens_requested == 1 ? 'singular' : 'plural'

    content_tag :p, class: 'mb-0 text-muted d-inline-flex align-items-center' do
      icon('fas', 'flask mr-1') + t("labs.table.requests.samples_needed.#{text}", requested_number: line_item.number_of_specimens_requested, requested_size: line_item.groups_source.group.process_sample_size ? " &geq; #{line_item.minimum_sample_size}" : "").html_safe
    end
  end

  def lab_status_context(lab)
    klass =
      if lab.retrieved?
        'badge-success'
      elsif lab.released?
        'badge-primary'
      elsif lab.discarded?
        'badge-secondary'
      else
        'badge-warning'
      end

    content_tag(:span, lab.human_status, class: ['badge p-2 ml-sm-2 lab-status', klass])
  end

  def lab_actions(lab)
    actions = []

    actions.push(retrieve_lab_button(lab)) if lab.released? && lab.group.process_specimen_retrieval?
    actions.push(reset_lab_button(lab))   unless lab.available?
    actions.push(discard_lab_button(lab))  unless lab.retrieved? || lab.discarded?

    content_tag :div, class: 'd-flex' do
      raw(actions.join)
    end
  end

  def release_lab_button(lab, line_item)
    content_tag :div, class: 'tooltip-wrapper', title: t(:labs)[:actions][:release_specimen], data: { toggle: 'tooltip' } do
      link_to lab_path(lab, lab_filter_params.merge(lab: { status: 'released', line_item_id: line_item.id, released_by: current_user.id })), remote: true, method: :patch, class: "btn btn-primary mr-2", data: { confirm_swal: 'true', title: t('labs.release_confirm.title', id: line_item.sparc_request.identifier), html: ' ' } do
        icon('fas', 'dolly')
      end
    end
  end

  def retrieve_lab_button(lab)
    link_to lab_path(lab, lab_filter_params.merge(lab: { status: 'retrieved' })), remote: true, method: :patch, class: "btn btn-success ml-1", title: t(:labs)[:actions][:retrieve_specimen], data: { toggle: "tooltip", confirm_swal: 'true', title: t('labs.retrieve_confirm.title') } do
      icon('fas', 'check-circle')
    end
  end

  def reset_lab_button(lab)
    link_to lab_path(lab, lab_filter_params.merge(lab: { status: 'available', line_item_id: nil, released_at: nil, released_by: nil, retrieved_at: nil, discarded_at: nil, discarded_by: nil, discard_reason: nil })), remote: true, method: :patch, class: "btn btn-warning ml-1", title: t(:labs)[:actions][:reset_specimen], data: { toggle: "tooltip", confirm_swal: 'true', title: t('labs.reset_confirm.title', available: I18n.t(:labs)[:statuses][:available]) } do
      icon('fas', 'redo')
    end
  end

  def discard_lab_button(lab)
    content_tag(:div, class: 'tooltip-wrapper', title: t(:labs)[:actions][:discard_specimen], data: { toggle: 'tooltip' }) do
      link_to lab_path(lab, lab_filter_params.merge(lab: { status: 'discarded', discarded_by: current_user.id })), remote: true, method: :patch, class: "btn btn-danger ml-1", data: { confirm_swal: 'true', title: t('labs.discard_confirm.title'), form: 'true', html: fields_for(:lab) { |f| f.text_area(:discard_reason, class: 'form-control mt-3', placeholder: t('labs.discard_confirm.reason_placeholder'), maxlength: 255) } } do
        icon('fas', 'trash-alt')
      end
    end
  end

  private

  def lab_filter_params
    {
      term:               params[:term],
      released_at_start:  params[:released_at_start],
      released_at_end:    params[:released_at_end],
      status:             params[:status],
      source:             params[:source],
      sort_by:            params[:sort_by],
      sort_order:         params[:sort_order],
      page:               params[:page]
    }
  end
end
