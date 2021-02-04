module LabHonestBrokersHelper
  def honest_broker_sort_filter_options(sort_by)
    sort_by = sort_by.blank? ? 'name' : sort_by
    options_for_select(
      [:name, :email].map do |k|
        [User.human_attribute_name(k), k]
      end.sort, sort_by
    )
  end

  def honest_broker_sort_order_options(sort_order)
    sort_order = sort_order.blank? ? 'asc' : params[:sort_order]
    options_for_select(
      t(:constants)[:order].invert,
      sort_order
    )
  end

  def remove_honest_broker_button(lhb)
    link_to icon('fas', 'trash'), group_lab_honest_brokers_path(lhb, group_id: lhb.group_id), remote: true, method: :delete, class: 'btn btn-danger', title: t('groups.lab_honest_brokers.tooltips.delete'), data: { toggle: 'tooltip', confirm_swal: 'true' }
  end
end
