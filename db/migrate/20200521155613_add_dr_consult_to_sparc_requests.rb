class AddDrConsultToSparcRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :sparc_requests, :dr_consult, :boolean, default: false, after: :status

    SparcRequest.reset_column_information
    SparcRequest.where.not(submitted_at: nil).update_all(dr_consult: true)
  end
end
