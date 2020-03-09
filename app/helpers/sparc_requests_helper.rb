module SparcRequestsHelper
  def request_sort_filter_options(sort_by)
    sort_by ||= 'created_at'
    options_for_select(
      [:protocol_id, :title, :short_title, :time_remaining, :primary_pi, :requester, :status, :created_at].map do |k|
        [SparcRequest.human_attribute_name(k), k]
      end.sort, sort_by
    )
  end

  def request_status_filter_options(status)
    options_for_select([
      [t('requests.filters.all_status'), ''],
      [t('requests.filters.active_status'), '', selected: true],
      [t('requests.statuses.completed'), class: 'text-success'],
      [t('requests.statuses.in_process'), class: 'text-primary'],
      [t('requests.statuses.pending'), class: 'text-warning'],
      [t('requests.statuses.cancelled'), class: 'text-secondary']
    ], status)
  end

  def request_title_display(sr)
    # Bootstrap 4 Popover's fallbackPlacement attribute is broken
    # so we need to use a second element to change the positioning
    # of popovers on XS screens
    raw(
      content_tag(:span, sr.identifier.truncate(60), class: 'mt-0 mt-sm-1') +
      content_tag(:span, class: 'mt-0 mt-sm-1') do
        link_to(icon('fas', 'info-circle'), 'javascript:void(0)', class: 'd-none d-xl-inline-block ml-2', data: { toggle: 'popover', html: 'true', placement: 'top', container: 'body', trigger: 'manual', content: render('sparc_requests/details_popover', request: sr) }) +
        link_to(icon('fas', 'info-circle'), 'javascript:void(0)', class: 'd-inline-block d-xl-none ml-2', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: render('sparc_requests/details_popover', request: sr) })
      end
    )
  end

  def primary_pi_display(sr)
    content_tag :span do
      icon('fas', 'user mr-2') + t('requests.table.primary_pi', name: sr.primary_pi.display_name)
    end
  end

  def requester_display(sr)
    name = link_to sr.user.full_name, 'javascript:void(0)', data: { toggle: 'popover', html: 'true', placement: 'right', container: 'body', trigger: 'manual', content: render('users/user_popover', user: sr.user) }

    content_tag :span do
      icon('fas', 'user mr-2') + t('requests.table.requester', name: name, time_elapsed: distance_of_time_in_words(sr.submitted_at, DateTime.now.utc)).html_safe
    end
  end

  def request_duration_display(sr)
    if sr.end_date < DateTime.now.utc
      content_tag :span, class: 'text-danger' do
        icon('fas', 'hourglass-end mr-2') + t('requests.table.duration.overdue', duration: distance_of_time_in_words(sr.end_date, DateTime.now.utc).capitalize)
      end
    elsif ((sr.end_date - DateTime.now.utc).to_i / (60*60*24)) <= 30
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

    chart = content_tag :div do
      content_tag(:h5, t('requests.table.specimens.chart.header', source: li.source.value), class: 'mb-3 font-weight-bold') +
      content_tag(:div, t('requests.table.specimens.chart.loading'), id: "chart-#{li.id}", class: 'rates-chart')
    end

    content = icon('fas', 'flask mr-2') + 
      if li.group.process_sample_size?
        t("requests.table.specimens.line_item_with_sample_size.#{text}", source: li.source.value, amount_requested: li.number_of_specimens_requested, min_sample_size: li.minimum_sample_size).html_safe
      else
        t("requests.table.specimens.line_item_no_sample_size.#{text}", source: li.source.value, amount_requested: li.number_of_specimens_requested).html_safe
      end

    content_tag :span do
      link_to content, 'javascript:void(0)', class: 'specimen-line-item d-none d-xl-inline-flex', data: { toggle: 'popover', html: 'true', placement: 'right', container: 'body', trigger: 'manual', content: chart, chart_id: "chart-#{li.id}", three_mo: li.three_month_accrual, six_mo: li.six_month_accrual, one_yr: li.one_year_accrual }
      link_to content, 'javascript:void(0)', class: 'specimen-line-item d-inline-flex d-xl-none', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: chart, chart_id: "chart-#{li.id}", three_mo: li.three_month_accrual, six_mo: li.six_month_accrual, one_yr: li.one_year_accrual }
    end
  end

  def query_display(li)
    content_tag :span, class: 'd-flex' do
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
    content_tag :div, class: 'd-inline-flex' do
      raw([
        complete_request_button(sr),
        finalize_request_button(sr),
        edit_request_button(sr),
        cancel_request_button(sr)
      ].join(''))
    end
  end

  def complete_request_button(sr)
    if sr.in_process? && (current_user.honest_broker? || current_user.admin?)
      link_to t(:actions)[:complete_request], update_status_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:completed] }), remote: true, method: :patch, class: 'btn btn-success complete-request', title: t(:requests)[:tooltips][:complete], data: { toggle: 'tooltip' }
    end
  end

  def finalize_request_button(sr)
    if sr.pending? && (current_user.honest_broker? || current_user.admin?)
      link_to icon('fas', 'check-circle'), update_status_sparc_request_path(sr, status: params[:status], sort_by: params[:sort_by], sort_order: params[:sort_order], sparc_request: { status: t(:requests)[:statuses][:in_process] }), remote: true, method: :patch, class: 'btn btn-primary finalize-request', title: t(:requests)[:tooltips][:finalize], data: { toggle: 'tooltip' }
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
