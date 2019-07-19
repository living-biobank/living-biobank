class AddDisplayPatientInformationToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :display_patient_information, :boolean, after: :process_sample_size
  end
end
