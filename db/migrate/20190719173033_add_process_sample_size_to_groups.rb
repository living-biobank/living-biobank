class AddProcessSampleSizeToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :process_sample_size, :boolean, after: :process_specimen_retrieval
  end
end
