module LabHonestBrokersHelper
  def remove_honest_broker_button(user, group)
    link_to icon('fas', 'times'), group_lab_honest_brokers_path(group, user_id: user.id), remote: true, method: :delete, class: 'btn btn-danger', data: { confirm_swal: 'true' }
  end
end
