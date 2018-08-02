module LabsHelper
  def lab_actions(lab)
    [
      release_specimen_button(lab),
      delete_specimen_button(lab)
    ].join("")
  end

  def release_specimen_button(lab)
    link_to t(:actions)[:release], new_specimen_record_path(lab_id: lab.id), remote: true, class: 'btn btn-primary mr-2'
  end

  def delete_specimen_button(lab)
    link_to t(:labs)[:fields][:delete], lab_path(lab), remote: true, method: :patch, class: 'btn btn-danger delete-specimen', data: { confirm_swal: true }
  end
end
