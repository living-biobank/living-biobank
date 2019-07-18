class AddSources < ActiveRecord::Migration[5.1]
  def change
    create_table :sources do |t|
      t.references  :group
      t.string      :key
      t.string      :value
      t.timestamps
    end
  end
end
