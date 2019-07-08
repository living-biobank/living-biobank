class AddSampleSizetoLabs < ActiveRecord::Migration[5.1]
  def change
    add_column :labs, :sample_size, :string, after: :specimen_source
  end
end
