module ControlPanel::GroupsHelper
  def edit_group_button(group)
    link_to edit_control_panel_group_path(group), remote: true, class: 'btn btn-warning', title: t(:control_panel)[:group_management][:tooltips][:edit_group], data: { toggle: "tooltip" } do
      icon('fas', 'pencil-alt')
    end
  end
end
