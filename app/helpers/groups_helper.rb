module GroupsHelper
  def group_breadcrumb(group)
    content_tag :span do
      index_title = icon('fas', 'clipboard-list') + t('groups.header')
      header      = action_name == 'index' ? index_title : link_to(index_title, groups_path)
      header     += icon('fas', 'chevron-right fa-xs mx-2') + t('groups.new') if group.present? && group.new_record?
      header     += icon('fas', 'chevron-right fa-xs mx-2') + group.name      if ['edit', 'update'].include?(action_name)
      header
    end
  end

  def group_sources_display(group)
    group.groups_sources.active.map do |groups_source|
      content_tag(:span, "- #{groups_source.source.value} (#{groups_source.source.key})", class: 'd-flex')
    end.join('')
  end

  def group_services_display(group)
    %w(pending in_process).map do |status|
      if (services = group.services.select{ |s| s.status == status }).any?
        content_tag(:h6, t("groups.table.services.#{status}"), class: 'font-weight-bold mb-0') + 
        services.map do |service|
          content_tag(:span, "- #{service.sparc_service.name}", class: 'd-flex')
        end.join('').html_safe
      end
    end.join('').html_safe
  end

  def edit_group_button(group)
    link_to edit_group_path(group, group_filter_params.merge(tab: 'details')), class: 'btn btn-warning', title: t('groups.tooltips.edit'), data: { toggle: "tooltip" } do
      icon('fas', 'pencil-alt')
    end
  end

  def group_filter_params
    {
      term:       params[:term],
      sort_by:    params[:sort_by],
      sort_order: params[:sort_order],
      page:       params[:page]
    }
  end
end
