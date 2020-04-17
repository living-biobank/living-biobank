module SparcRequestsHelper
  def request_sort_filter_options(sort_by)
    sort_by = sort_by.blank? ? 'created_at' : sort_by
    options_for_select(
      [:id, :protocol_id, :title, :short_title, :time_remaining, :requester, :status, :created_at].map do |k|
        [SparcRequest.human_attribute_name(k), k]
      end.sort, sort_by
    )
  end

  def request_sort_order_options(sort_order)
    sort_order = sort_order.blank? ? 'desc' : params[:sort_order]
    options_for_select(
      t(:constants)[:order].invert,
      sort_order
    )
  end

  def request_status_filter_options(status)
    status = status.blank? ? 'active' : status
    options_for_select([
      [t('requests.filters.all_status'), 'any'],
      [t('requests.filters.active_status'), 'active'],
      [t('requests.statuses.completed'), class: 'text-success'],
      [t('requests.statuses.in_process'), class: 'text-primary'],
      [t('requests.statuses.pending'), class: 'text-warning'],
      [t('requests.statuses.cancelled'), class: 'text-secondary']
    ], status)
  end

  def request_title_display(sr, opts={})
    # Bootstrap 4 Popover's fallbackPlacement attribute is broken
    # so we need to use a second element to change the positioning
    # of popovers on XS screens
    raw(
      content_tag(:span, t('requests.table.header', id: sr.identifier), class: 'mt-0 mt-sm-1 mr-2') +
      content_tag(:small, sr.protocol.identifier.truncate(60), class: 'text-muted d-inline-flex align-items-center mt-0 mt-sm-1') +
      if opts[:popover] && sr.previously_submitted?
        content_tag(:span, class: 'mt-0 mt-sm-1') do
          link_to(icon('fas', 'info-circle'), 'javascript:void(0)', class: 'd-none d-xl-inline-block ml-2', data: { toggle: 'popover', html: 'true', placement: 'top', container: 'body', trigger: 'manual', content: render('sparc_requests/details_popover', request: sr) }) +
          link_to(icon('fas', 'info-circle'), 'javascript:void(0)', class: 'd-inline-block d-xl-none ml-2', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: render('sparc_requests/details_popover', request: sr) })
        end
      else
        ""
      end
    )
  end

  def primary_pi_display(sr)
    content_tag :span do
      icon('fas', 'user mr-1') + t('requests.table.primary_pi', name: sr.primary_pi.display_name)
    end
  end

  def requester_display(sr)
    name =
      link_to(sr.requester.full_name, 'javascript:void(0)', class: 'd-none d-xl-inline-block mx-1', data: { toggle: 'popover', html: 'true', placement: 'right', container: 'body', trigger: 'manual', content: render('users/user_popover', user: sr.requester) }) +
      link_to(sr.requester.full_name, 'javascript:void(0)', class: 'd-inline-block d-xl-none mx-1', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: render('users/user_popover', user: sr.requester) })

    content_tag :span, class: 'd-inline-flex align-items-center flex-wrap' do
      icon('fas', 'user mr-1') + t('requests.table.requester', name: name, time_elapsed: distance_of_time_in_words(sr.submitted_at, DateTime.now.utc)).html_safe
    end
  end

  def request_updater_display(sr)
    name =
      link_to(sr.updater.full_name, 'javascript:void(0)', class: 'd-none d-xl-inline-block mx-1', data: { toggle: 'popover', html: 'true', placement: 'right', container: 'body', trigger: 'manual', content: render('users/user_popover', user: sr.updater) }) +
      link_to(sr.updater.full_name, 'javascript:void(0)', class: 'd-inline-block d-xl-none mx-1', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: render('users/user_popover', user: sr.updater) })

    content_tag :span, class: 'd-inline-flex align-items-center flex-wrap' do
      icon('fas', 'user mr-1') + t('requests.table.updater', name: name, date: format_date(sr.updated_at)).html_safe
    end
  end

  def request_completer_display(sr)
    name =
      link_to(sr.completer.full_name, 'javascript:void(0)', class: 'd-none d-xl-inline-block', data: { toggle: 'popover', html: 'true', placement: 'right', container: 'body', trigger: 'manual', content: render('users/user_popover', user: sr.completer) }) +
      link_to(sr.completer.full_name, 'javascript:void(0)', class: 'd-inline-block d-xl-none', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: render('users/user_popover', user: sr.completer) })

    content_tag :span, class: 'text-success' do
      icon('fas', 'user mr-1') + t('requests.table.completer', name: name, date: format_date(sr.completed_at)).html_safe
    end
  end

  def request_canceller_display(sr)
    name =
      link_to(sr.canceller.full_name, 'javascript:void(0)', class: 'd-none d-xl-inline-block', data: { toggle: 'popover', html: 'true', placement: 'right', container: 'body', trigger: 'manual', content: render('users/user_popover', user: sr.canceller) }) +
      link_to(sr.canceller.full_name, 'javascript:void(0)', class: 'd-inline-block d-xl-none', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: render('users/user_popover', user: sr.canceller) })

    content_tag :span, class: 'text-danger' do
      icon('fas', 'user mr-1') + t('requests.table.canceller', name: name, date: format_date(sr.cancelled_at)).html_safe
    end
  end

  def request_duration_display(sr)
    if sr.end_date < DateTime.now.utc
      content_tag :span, class: 'd-inline-flex align-items-center text-danger' do
        icon('fas', 'hourglass-end mr-1') + t('requests.table.duration.overdue', duration: distance_of_time_in_words(sr.end_date, DateTime.now.utc).capitalize)
      end
    elsif ((sr.end_date - DateTime.now.utc).to_i / (60*60*24)) <= 30
      content_tag :span, class: 'd-inline-flex align-items-center text-warning' do
        icon('fas', 'hourglass-half mr-1') + t('requests.table.duration.remaining', duration: distance_of_time_in_words(DateTime.now.utc, sr.end_date).capitalize)
      end
    else
      content_tag :span, class: 'd-inline-flex align-items-center text-muted' do
        icon('fas', 'hourglass-half mr-1') + t('requests.table.duration.remaining', duration: distance_of_time_in_words(DateTime.now.utc, sr.end_date).capitalize)
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
        t("requests.table.specimens.line_item_with_sample_size.#{text}", source: li.source.value, amount_requested: li.number_of_specimens_requested, min_sample_size: li.minimum_sample_size)
      else
        t("requests.table.specimens.line_item_no_sample_size.#{text}", source: li.source.value, amount_requested: li.number_of_specimens_requested)
      end

    content_tag :span do
      link_to(content, 'javascript:void(0)', class: 'specimen-line-item d-none d-xl-inline-flex', data: { toggle: 'popover', html: 'true', placement: 'right', container: 'body', trigger: 'manual', content: chart, chart_id: "chart-#{li.id}", three_mo: li.three_month_accrual, six_mo: li.six_month_accrual, one_yr: li.one_year_accrual }) +
      link_to(content, 'javascript:void(0)', class: 'specimen-line-item d-inline-flex d-xl-none', data: { toggle: 'popover', html: 'true', placement: 'bottom', container: 'body', trigger: 'click', content: chart, chart_id: "chart-#{li.id}", three_mo: li.three_month_accrual, six_mo: li.six_month_accrual, one_yr: li.one_year_accrual })
    end
  end

  def query_display(li)
    content_tag :span, class: 'd-flex text-muted' do
      icon('fas', 'database fa-sm mr-2') + content_tag(:small, li.query_name.truncate(50))
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
        cancel_request_button(sr),
        reset_request_button(sr)
      ].join(''))
    end
  end

  def complete_request_button(sr)
    if sr.in_process? && (current_user.data_honest_broker? || current_user.admin?)
      link_to t(:actions)[:complete_request], update_status_sparc_request_path(sr, request_filter_params.merge(sparc_request: { status: t(:requests)[:statuses][:completed], completed_by: current_user.id })), remote: true, method: :patch, class: 'btn btn-success complete-request', title: t(:requests)[:tooltips][:complete], data: { toggle: 'tooltip', confirm_swal: 'true', title: t('requests.complete_confirm.title', id: sr.identifier), text: t('requests.complete_confirm.text') }
    end
  end

  def finalize_request_button(sr)
    if sr.pending? && (current_user.data_honest_broker? || current_user.admin?)
      link_to icon('fas', 'check-circle'), update_status_sparc_request_path(sr, request_filter_params.merge(sparc_request: { status: t(:requests)[:statuses][:in_process], finalized_by: current_user.id })), remote: true, method: :patch, class: 'btn btn-primary finalize-request', title: t(:requests)[:tooltips][:finalize], data: { toggle: 'tooltip', confirm_swal: 'true', title: t('requests.finalize_confirm.title', id: sr.identifier), text: t('requests.finalize_confirm.text') }
    end
  end

  def edit_request_button(sr)
    if sr.pending? || (sr.in_process? && (current_user.data_honest_broker? || current_user.admin?))
      link_to icon('fas', 'edit'), edit_sparc_request_path(sr, request_filter_params), remote: true, class: 'btn btn-warning edit-request ml-1', title: t(:requests)[:tooltips][:edit], data: { toggle: 'tooltip' }
    end
  end

  def cancel_request_button(sr)
    if sr.pending? || sr.draft?
      link_to icon('fas', 'trash'), update_status_sparc_request_path(sr, request_filter_params.merge(sparc_request: { status: t(:requests)[:statuses][:cancelled], cancelled_by: current_user.id })), remote: true, method: :patch, class: 'btn btn-danger cancel-request ml-1', title: t(:requests)[:tooltips][:cancel], data: { toggle: 'tooltip', confirm_swal: 'true' }
    end
  end

  def reset_request_button(sr)
    # Only DHBs and Admins can reset previously "In Process" or "Complete" requests
    if ((sr.completed? || (sr.cancelled? && sr.previously_finalized?)) && (current_user.data_honest_broker? || current_user.admin?)) || (sr.cancelled? && !sr.previously_finalized?)
      if sr.previously_finalized?
        status  = t('requests.statuses.in_process')
        klass   = 'text-primary'
      elsif sr.previously_submitted?
        status  = t('requests.statuses.pending')
        klass   = 'text-warning'
      else
        status  = t('requests.statuses.draft')
        klass   = 'text-warning'
      end
      link_to update_status_sparc_request_path(sr, request_filter_params.merge(sparc_request: { status: status, completed_at: nil, completed_by: nil, cancelled_at: nil, cancelled_by: nil })), remote: true, method: :patch, class: 'btn btn-warning ml-1', title: t('requests.tooltips.reset'), data: { toggle: 'tooltip', confirm_swal: 'true', title: t('requests.reset_confirm.title', klass: klass, status: status) } do
        icon('fas', 'redo')
      end
    end
  end

  def request_filter_params
    {
      term:       params[:term],
      status:     params[:status],
      sort_by:    params[:sort_by],
      sort_order: params[:sort_order],
      page:       params[:page]
    }
  end
end
