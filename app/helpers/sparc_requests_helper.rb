module SparcRequestsHelper
  def request_time_estimate(sr)
    sr.time_estimate == '>2 years' ? fa_icon('exclamation-circle', text: sr.time_estimate, right: true, title: t(:requests)[:tooltips][:time_estimate], class: 'text-warning') : sr.time_estimate
  end

  def request_actions(sr)
    content_tag(:div, class: 'btn-group', role: 'group') do
      raw([
        finalize_request_button(sr),
        edit_request_button(sr),
        cancel_request_button(sr)
      ].join(''))
    end
  end

  def finalize_request_button(sr)
    link_to sparc_request_update_status_path(sr, sparc_request: { status: 'In Process' }), remote: true, method: :patch, title: t(:requests)[:tooltips][:finalize], class: 'btn btn-success' do
      fa_icon 'check'
    end
  end

  def edit_request_button(sr)
    link_to edit_sparc_request_path(sr), remote: true, title: t(:requests)[:tooltips][:edit], class: 'btn btn-warning' do
      fa_icon 'edit'
    end
  end

  def cancel_request_button(sr)
    link_to sparc_request_update_status_path(sr, sparc_request: { status: 'Cancelled' }), remote: true, method: :patch, title: t(:requests)[:tooltips][:cancel], class: 'btn btn-danger', data: { confirm_swal: true } do
      fa_icon 'times'
    end
  end
end
