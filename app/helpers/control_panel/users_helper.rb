module ControlPanel::UsersHelper
  def user_permissions_display(user)
    if user.admin || user.lab_honest_broker? || user.data_honest_broker?
      content_tag(:span, class: 'd-flex d-sm-inline-flex text-danger mr-1', title: user.admin? ? t(:control_panel)[:users][:tooltips][:admin] : '', data: { toggle: "tooltip" }) do
        icon('fas', 'user-cog fa-lg', class: user.admin? ? '' : 'invisible')
      end +
      content_tag(:span, class: 'd-flex d-sm-inline-flex text-primary mr-1', title: user.lab_honest_broker? ? t(:control_panel)[:users][:tooltips][:lab_honest_broker] : '', data: { toggle: "tooltip" }) do
        icon('fas', 'user-tag fa-lg', class: user.lab_honest_broker? ? '' : 'invisible')
      end +
      content_tag(:span, class: 'd-flex d-sm-inline-flex text-success mr-1', title: user.data_honest_broker? ? t(:control_panel)[:users][:tooltips][:data_honest_broker] : '', data: { toggle: "tooltip" }) do
        icon('fas', 'user-check fa-lg', class: user.data_honest_broker? ? '' : 'invisible')
      end
    else
      content_tag(:span, class: 'd-inline-flex', title: t(:control_panel)[:users][:tooltips][:user], data: { toggle: "tooltip" }) do
        icon('fas', 'user fa-lg')
      end
    end
  end

  def edit_user_button(user)
    link_to edit_control_panel_user_path(user), remote: true, class: 'btn btn-warning', title: t(:control_panel)[:users][:tooltips][:edit_user], data: { toggle: "tooltip" } do
      icon('fas', 'pencil-alt')
    end
  end
end
