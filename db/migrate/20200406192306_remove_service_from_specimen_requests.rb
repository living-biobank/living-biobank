class RemoveServiceFromSpecimenRequests < ActiveRecord::Migration[5.2]
  class Service < ApplicationRecord
    default_scope { order(:id) }
  end

  class Variable < ApplicationRecord
    default_scope { order(:id) }
  end

  def change
    LineItem.specimen_requests.update_all(service_id: nil)
    lis = LineItem.additional_services.where.not(service_id: Service.all.pluck(:sparc_id) + Variable.all.pluck(:service_id))

    lis.each do |li|
      if li.sparc_line_item
        if li.sub_service_request.line_items.length == 1
          li.sub_service_request.destroy
        else
          li.sparc_line_item.destroy
        end
      end
      li.destroy
    end
  end
end
