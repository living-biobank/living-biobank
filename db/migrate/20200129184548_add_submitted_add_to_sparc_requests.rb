class AddSubmittedAddToSparcRequests < ActiveRecord::Migration[5.1]
  def change
    unless column_exists?(:sparc_requests, :submitted_at)
      add_column :sparc_requests, :submitted_at, :datetime, after: :updated_at
    end

    SparcRequest.reset_column_information

    ActiveRecord::Base.transaction do
      SparcRequest.where(submitted_at: nil).each do |sr|
        if sr.pending?
          # Update pending requests using updated_at because its last update would have been
          # upon submission
          sr.update_column(:submitted_at, sr.updated_at)
        elsif !sr.draft?
          # Update any other non-draft requests using created_at because they were updated
          # after submission already
          sr.update_column(:submitted_at, sr.created_at)
        end
      end
    end
  end
end
