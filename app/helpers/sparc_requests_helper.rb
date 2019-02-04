module SparcRequestsHelper
  def request_sort_filter_options(sort_by)
    options_for_select(
      [:short_title, :start_date, :end_date, :primary_pi, :service_source, :specimens_requested, :minimum_sample, :status].map do |k| 
        [t(:requests)[:fields][k], k]
      end, sort_by
    )
  end

  def request_status_filter_options(status)
    options_for_select(
      [
        [t(:requests)[:statuses][:finalized], class: 'text-success'],
        [t(:requests)[:statuses][:pending], class: 'text-primary'],
        [t(:requests)[:statuses][:cancelled], class: 'text-secondary']
      ],
      status
    )
  end

  def status_context(sr)
    klass =
      if sr.completed?
        'badge-success'
      elsif sr.in_process?
        'badge-primary'
      elsif sr.cancelled?
        'badge-secondary'
      else
        'badge-warning'
      end

    content_tag(:span, sr.status, class: ['badge p-2', klass])
  end

  def request_time_estimate(sr)
    if sr.time_estimate == '>2 years'
      content_tag(:span, title: t(:requests)[:tooltips][:time_estimate], class: 'text-warning') do
        sr.time_estimate + icon('fas', 'exclamation-circle')
      end
    else
      sr.time_estimate
    end
  end

  def request_actions(sr)
    content_tag(:div, class: 'btn-group', role: 'group') do
      raw(
        [
          complete_request_button(sr),
          begin_request_button(sr),
          edit_request_button(sr),
          cancel_request_button(sr)
        ].join('')
      )
    end
  end

  def complete_request_button(sr)
    if sr.in_process?
      link_to sparc_request_update_status_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:completed] }), remote: true, method: :patch, title: t(:requests)[:tooltips][:complete], class: 'btn btn-success', data: { toggle: 'tooltip' } do
        'Complete'
      end
    end
  end

  def begin_request_button(sr)
    if sr.pending?
      link_to sparc_request_update_status_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:in_process] }), remote: true, method: :patch, title: t(:requests)[:tooltips][:finalize], class: 'btn btn-primary', data: { toggle: 'tooltip' } do
        icon('fas', 'check-circle')
      end
    end
  end

  def edit_request_button(sr)
    if sr.pending?
      link_to edit_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order]), remote: true, title: t(:requests)[:tooltips][:edit], class: 'btn btn-warning', data: { toggle: 'tooltip' } do
        icon('fas', 'edit')
      end
    end
  end

  def cancel_request_button(sr)
    if sr.pending?
      link_to sparc_request_update_status_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:cancelled] }), remote: true, method: :patch, title: t(:requests)[:tooltips][:cancel], class: 'btn btn-danger', data: { toggle: 'tooltip', confirm_swal: true } do
        icon('fas', 'trash')
      end
    end
  end
end
