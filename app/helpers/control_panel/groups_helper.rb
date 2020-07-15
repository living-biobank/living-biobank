module ControlPanel::GroupsHelper
  def group_sources_display(group)
    group.sources.map do |source|
      content_tag(:span, "- #{source.value} (#{source.key})", class: 'd-flex')
    end.join('')
  end

  def group_services_display(group)
    if group.variables.any?
      content_tag(:h6, t('control_panel.groups.table.variables'), class: 'font-weight-bold mb-0') +
      group.variables.map do |variable|
        content_tag(:span, "- #{variable.service.name} (#{variable.name})", class: 'd-flex')
      end.join('').html_safe
    else
      ""
    end +

    if group.services.any?
      content_tag(:h6, t('control_panel.groups.table.services'), class: 'font-weight-bold mb-0') +
      group.services.map do |service|
        content_tag(:span, "- #{service.sparc_service.name}", class: 'd-flex')
      end.join('').html_safe
    else
      ""
    end
  end

  def edit_group_button(group)
    link_to edit_control_panel_group_path(group, group_filter_params), remote: true, class: 'btn btn-warning', title: t('control_panel.groups.tooltips.edit'), data: { toggle: "tooltip" } do
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
