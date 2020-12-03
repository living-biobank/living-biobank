module UsersHelper
  def user_breadcrumb
  end

  def user_privileges_filter_options(privileges)
    privileges = privileges.blank? ? 'any' : privileges
    options_for_select([
      [t('users.filters.any_privileges'),       'any',    data: { content: content_tag(:span, icon('fas', 'user mr-1 invisible') + t('users.filters.any_privileges')) }],
      [t('users.tooltips.user'),                'user',   data: { content: content_tag(:span, icon('fas', 'user mr-1') + t('users.tooltips.user')) }],
      [t('users.tooltips.admin'),               'admin',  data: { content: content_tag(:span, icon('fas', 'user-cog mr-1') + t('users.tooltips.admin'), class: 'text-danger') }],
      [t('users.tooltips.lab_honest_broker'),   'lhb',    data: { content: content_tag(:span, icon('fas', 'user-tag mr-1') + t('users.tooltips.lab_honest_broker'), class: 'text-primary') }],
      [t('users.tooltips.data_honest_broker'),  'dhb',    data: { content: content_tag(:span, icon('fas', 'user-check mr-1') + t('users.tooltips.data_honest_broker'), class: 'text-success') }],
    ], privileges)
  end

  def user_groups_filter_options(groups)
    groups = groups.blank? ? 'any' : groups
    options_for_select([[t('users.filters.any_group'), 'any']], groups) +
    options_from_collection_for_select(Group.all, :name, :name, groups)
  end

  def mobile_user_display(user)
    content_tag(:span, user.full_name, class: 'd-flex') +
    content_tag(:span, user.email, class: 'd-flex')
  end

  def user_privileges_display(user)
    if user.admin || user.lab_honest_broker? || user.data_honest_broker?
      content_tag(:span, class: 'tooltip-wrapper d-flex d-sm-inline-flex text-danger mr-1', title: user.admin? ? t('users.tooltips.admin') : '', data: { toggle: "tooltip" }) do
        icon('fas', 'user-cog fa-lg', class: user.admin? ? '' : 'invisible')
      end +
      content_tag(:span, class: 'tooltip-wrapper d-flex d-sm-inline-flex text-primary mr-1', title: user.lab_honest_broker? ? t('users.tooltips.lab_honest_broker') : '', data: { toggle: "tooltip" }) do
        icon('fas', 'user-tag fa-lg', class: user.lab_honest_broker? ? '' : 'invisible')
      end +
      content_tag(:span, class: 'tooltip-wrapper d-flex d-sm-inline-flex text-success mr-1', title: user.data_honest_broker? ? t('users.tooltips.data_honest_broker') : '', data: { toggle: "tooltip" }) do
        icon('fas', 'user-check fa-lg', class: user.data_honest_broker? ? '' : 'invisible')
      end
    else
      content_tag(:span, class: 'tooltip-wrapper d-inline-flex', title: t('users.tooltips.user'), data: { toggle: "tooltip" }) do
        icon('fas', 'user fa-lg')
      end
    end
  end

  def user_groups_display(user)
    user.groups.map do |group|
      content_tag(:span, "- #{group.name}", class: 'd-flex')
    end.join('')
  end

  def edit_user_button(user)
    link_to edit_user_path(user, user_filter_params), remote: true, class: 'btn btn-warning', title: t('users.tooltips.edit_user'), data: { toggle: "tooltip" } do
      icon('fas', 'pencil-alt')
    end
  end

  def user_filter_params
    {
      term:       params[:term],
      privileges: params[:privileges],
      groups:     params[:groups],
      sort_by:    params[:sort_by],
      sort_order: params[:sort_order],
      page:       params[:page]
    }
  end
end
