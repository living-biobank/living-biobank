module GroupsSourcesHelper
  def groups_source_sort_filter_options(sort_by)
    sort_by = sort_by.blank? ? 'name' : sort_by
    options_for_select(
      [:name, :description, :discard_age].map do |k|
        [GroupsSource.human_attribute_name(k), k]
      end.concat(
      [:key, :value].map do |k|
        [Source.human_attribute_name(k), k]
      end
      ).sort, sort_by
    )
  end

  def groups_source_sort_order_options(sort_order)
    sort_order = sort_order.blank? ? 'asc' : params[:sort_order]
    options_for_select(
      t(:constants)[:order].invert,
      sort_order
    )
  end

  def groups_source_actions(groups_source)
    content_tag :div, class: 'd-inline-flex' do
      raw([
        edit_groups_source_button(groups_source)
      ].join(''))
    end
  end

  def edit_groups_source_button(groups_source)
    link_to icon('fas', 'pencil-alt'), edit_group_groups_source_path(groups_source.group, groups_source), remote: true, class: 'btn btn-warning', title: t('groups.sources.tooltips.edit'), data: { toggle: 'tooltip' }
  end

  # Removed for now pending discussions
  # def delete_groups_source_button(groups_source)
  #   link_to icon('fas', 'trash'), group_groups_source_path(group, groups_source), remote: true, method: :delete, class: 'btn btn-danger', title: t('groups.sources.tooltips.delete'), data: { toggle: 'tooltip', confirm_swal: 'true' }
  # end
end
