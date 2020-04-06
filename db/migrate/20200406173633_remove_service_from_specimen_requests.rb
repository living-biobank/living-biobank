class RemoveServiceFromSpecimenRequests < ActiveRecord::Migration[5.2]
  def change
    SparcRequest.all.eager_load(:specimen_requests, :additional_services).each do |sr|
      if srli = sr.specimen_requests.detect{ |srli| srli.service_id.present? }
        service_id = srli.service_id
        sr.specimen_requests.update_all(service_id: nil)

        if as = sr.additional_services.detect{ |asli| asli.service_id == service_id }
          as.sub_service_request.destroy
          as.destroy
        end
      end
    end
  end
end
