module ServicesHelper
  def service_sort_filter_options(sort_by)
    sort_by = sort_by.blank? ? 'position' : sort_by
    options_for_select(
      [:name, :position, :organization, :condition, :status].map do |k|
        [Service.human_attribute_name(k), k]
      end.sort, sort_by
    )
  end

  def service_sort_order_options(sort_order)
    sort_order = sort_order.blank? ? 'asc' : params[:sort_order]
    options_for_select(
      t(:constants)[:order].invert,
      sort_order
    )
  end

  def service_status_filter_options(status)
    options_for_select([
      [t('groups.services.filters.all_status'), 'any'],
      [t('requests.statuses.in_process'),   'in_process', class: 'text-primary'],
      [t('requests.statuses.pending'),      'pending',    class: 'text-warning']
    ], status)
  end

  def service_condition_filter_options(condition)
    options_for_select((
      [[t('groups.services.filters.all_condition'), 'any']] +
      t('groups.services.conditions').invert.sort +
      [[t('groups.services.filters.no_condition'), 'none']]
    ), condition)
  end

  def format_service_status(service)
    klass =
      case service.status
      when 'complete'
        'text-success'
      when 'in_process'
        'text-primary'
      when 'pending'
        'text-warning'
      when 'cancelled'
        'text-secondary'
      end
    content_tag(:span, service.human_status, class: klass)
  end

  def service_org_hierarchy(service)
    service.organization.org_tree.map do |org|
      content_tag(:span, org.abbreviation, class: "text-#{org.type.downcase}")
    end.join(icon('fas', 'caret-right mx-1'))
  end

  def service_cpt_code(service)
    if service.cpt_code.blank?
      ""
    else
      content_tag(:span, "#{SPARC::Service.human_attribute_name(:cpt_code)}: ") + content_tag(:span, service.cpt_code)
    end
  end

  def service_actions(service)
    content_tag :div, class: 'd-inline-flex' do
      raw([
        edit_service_button(service), 
        delete_service_button(service)
      ].join(''))
    end
  end

  def delete_service_button(service)
    link_to icon('fas', 'trash-alt'), group_service_path(service, group_id: service.group_id), method: :delete, remote: true, class: 'btn btn-danger mx-1', title: t('groups.services.tooltips.delete'), data: { toggle: 'tooltip', confirm_swal: true, title: t('groups.services.delete_confirm.title'), text: '', confirm_text: "Yes", cancel_text: "No" }
  end

  def edit_service_button(service)
    link_to icon('fas', 'edit'), edit_group_service_path(service, group_id: service.group_id), remote: true, class: 'btn btn-warning mx-1', title: t('groups.services.tooltips.edit'), data: { toggle: 'tooltip' }
  end
end
