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

  def request_title_display(sr)
    # Bootstrap 4 Popover's fallbackPlacement attribute is broken
    # so we need to use a second element to change the positioning
    # of popovers on XS screens
    raw(
      sr.identifier.truncate(60) +
      link_to(icon('fas', 'info-circle ml-2'), 'javascript:void(0)', title: sr.identifier, class: 'd-none d-md-inline-block', data: { toggle: 'popover', html: 'true', placement: 'right', container: 'body', trigger: 'click hover', content: render('sparc_requests/details_popover', request: sr) }) +
      link_to(icon('fas', 'info-circle ml-2'), 'javascript:void(0)', title: sr.identifier, class: 'd-inline-block d-md-none', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click hover', content: render('sparc_requests/details_popover', request: sr) })
    )
  end

  def primary_pi_display(sr)
    content_tag :span do
      icon('fas', 'user mr-2') + t('requests.table.primary_pi', name: sr.primary_pi.display_name)
    end
  end

  def requester_display(sr)
    content_tag :span do
      icon('fas', 'user mr-2') + t('requests.table.requester', name: sr.user.display_name)
    end
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

  def line_item_text(li)
    text = li.number_of_specimens_requested == 1 ? 'singular' : 'plural'

    content_tag :span do
      icon('fas', 'flask mr-2') + 
      if li.group.process_sample_size?
        t("requests.table.specimens.line_item_with_sample_size.#{text}", source: li.source.value, amount_requested: li.number_of_specimens_requested, min_sample_size: li.minimum_sample_size).html_safe
      else
        t("requests.table.specimens.line_item_no_sample_size.#{text}", source: li.source.value, amount_requested: li.number_of_specimens_requested).html_safe
      end
    end
  end

  def query_display(li)
    content_tag :span do
      icon('fas', 'database mr-2') + li.query_name.truncate(50)
    end
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

    content_tag(:span, sr.status, class: ['badge p-2 ml-sm-2 mb-sm-0 request-status', klass])
  end

  def request_actions(sr)
    content_tag :div do
      raw([
        complete_request_button(sr),
        finalize_request_button(sr),
        edit_request_button(sr),
        cancel_request_button(sr)
      ].join(''))
    end
  end

  def complete_request_button(sr)
    if current_user.honest_broker.present? && sr.in_process?
      link_to t(:actions)[:complete_request], update_status_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:completed] }), remote: true, method: :patch, class: 'btn btn-success complete-request', title: t(:requests)[:tooltips][:complete], data: { toggle: 'tooltip' }
    end
  end

  def finalize_request_button(sr)
    if sr.pending? && current_user.honest_broker.present?
      link_to icon('fas', 'check-circle'), update_status_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:in_process] }), remote: true, method: :patch, class: 'btn btn-success finalize-request', title: t(:requests)[:tooltips][:finalize], data: { toggle: 'tooltip' }
    end
  end

  def edit_request_button(sr)
    if sr.pending?
      link_to icon('fas', 'edit'), edit_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order]), remote: true, class: 'btn btn-warning edit-request ml-1', title: t(:requests)[:tooltips][:edit], data: { toggle: 'tooltip' }
    end
  end

  def cancel_request_button(sr)
    if sr.pending?
      link_to icon('fas', 'trash'), update_status_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:cancelled] }), remote: true, method: :patch, class: 'btn btn-danger cancel-request ml-1', title: t(:requests)[:tooltips][:cancel], data: { toggle: 'tooltip', confirm_swal: true }
    end
  end
end
