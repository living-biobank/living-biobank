module ControlPanel::GroupsHelper
  def edit_release_email_button(group)
    link_to edit_release_email_control_panel_group_path(group), remote: true, class: 'btn btn-primary', title: t('control_panel.groups.tooltips.edit_release_email'), data: { toggle: "tooltip" } do
      icon('fas', 'pencil-alt')
    end
  end

  def edit_discard_email_button(group)
    link_to edit_discard_email_control_panel_group_path(group), remote: true, class: 'btn btn-danger', title: t('control_panel.groups.tooltips.edit_discard_email'), data: { toggle: "tooltip" } do
      icon('fas', 'pencil-alt')
    end
  end
end
