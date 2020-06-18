class AddFinalizationEmailColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :finalize_email_to, :string, after: :display_patient_information
  end
end
