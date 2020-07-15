class CombineVariablesAndServices < ActiveRecord::Migration[5.2]
  class Variable < ApplicationRecord
    belongs_to :group
    belongs_to :service, class_name: "SPARC::Service"
  end

  def up
    add_column :services, :status,    :string, after: :sparc_id
    add_column :services, :condition, :string, after: :status

    Service.reset_column_information

    Service.update_all(:status, 'in_process')

    Variable.all.order(position: :desc).each do |v|
      Service.create(
        group:          v.group,
        sparc_service:  v.service,
        condition:      v.condition,
        position:       1,
        status:         'pending'
      )

      v.destroy
    end

    drop_table :variables
  end
end
