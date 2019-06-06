module SparcRequestsHelper
  def request_sort_filter_options(sort_by)
    options_for_select(
      [:protocol_id, :title, :short_title, :time_remaining, :primary_pi, :requester, :status].map do |k|
        [t(:requests)[:fields][k], k]
      end, sort_by
    )
  end

  def request_status_filter_options(status)
    options_for_select(
      [
        [t(:requests)[:statuses][:completed], class: 'text-success'],
        [t(:requests)[:statuses][:in_process], class: 'text-primary'],
        [t(:requests)[:statuses][:pending], class: 'text-warning'],
        [t(:requests)[:statuses][:cancelled], class: 'text-secondary']
      ],
      status
    )
  end

  def primary_pi_display(sr)
    icon('fas', 'user mr-2') + sr.primary_pi.display_name
  end

  def requester_display(sr)
    raw t('requests.table.requester', name: sr.user.display_name)
  end

  def request_duration_display(sr)
    if sr.end_date < DateTime.now.utc
      content_tag :span, class: 'text-danger' do
        icon('fas', 'hourglass-end mr-2') + t('requests.table.duration.overdue', duration: distance_of_time_in_words(sr.end_date, DateTime.now.utc).capitalize)
      end
    elsif (sr.end_date - DateTime.now.utc).to_i <= 30
      content_tag :span, class: 'text-warning' do
        icon('fas', 'hourglass-half mr-2') + t('requests.table.duration.remaining', duration: distance_of_time_in_words(DateTime.now.utc, sr.end_date).capitalize)
      end
    else
      content_tag :span do
        icon('fas', 'hourglass-half mr-2') + t('requests.table.duration.remaining', duration: distance_of_time_in_words(DateTime.now.utc, sr.end_date).capitalize)
      end
    end
  end

  def service_display(li)
    t('requests.table.service', service: li.service.abbreviation, source: li.service_source, amount_requested: li.number_of_specimens_requested, min_sample_size: li.minimum_sample_size).html_safe
  end

  def request_status_context(sr)
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

    content_tag(:span, sr.status, class: ['badge p-2 mb-sm-0 request-status', klass])
  end

  def request_actions(sr)
    raw([
      complete_request_button(sr),
      finalize_request_button(sr),
      edit_request_button(sr),
      cancel_request_button(sr)
    ].join(''))
  end

  def complete_request_button(sr)
    if current_user.honest_broker? && sr.in_process?
      content_tag(:button, t(:actions)[:complete_request], type: 'button', title: t(:requests)[:tooltips][:complete], class: 'btn btn-success complete-request', data: { toggle: 'tooltip', url: update_status_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:completed] }), method: :patch })
    end
  end

  def finalize_request_button(sr)
    if sr.pending? && current_user.honest_broker?
      content_tag(:button, icon('fas', 'check-circle'), type: 'button', title: t(:requests)[:tooltips][:finalize], class: 'btn btn-primary finalize-request', data: { toggle: 'tooltip', url: update_status_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:in_process] }), method: :patch })
    end
  end

  def edit_request_button(sr)
    if sr.pending?
      content_tag(:button, icon('fas', 'edit'), type: 'button', title: t(:requests)[:tooltips][:edit], class: 'btn btn-warning edit-request ml-1', data: { toggle: 'tooltip', url: edit_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order]) })
    end
  end

  def cancel_request_button(sr)
    if sr.pending?
      content_tag(:button, icon('fas', 'trash'), title: t(:requests)[:tooltips][:cancel], class: 'btn btn-danger cancel-request ml-1', data: { toggle: 'tooltip', confirm_swal: true, url: update_status_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:cancelled] }), method: :patch })
    end
  end
end
