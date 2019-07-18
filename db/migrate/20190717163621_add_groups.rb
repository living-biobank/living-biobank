class AddGroups < ActiveRecord::Migration[5.1]
  def up
    create_table :groups do |t|
      t.string    :name
      t.boolean   :process_specimen_retrieval
      t.timestamps
    end

    add_index :groups, :name, unique: true

    add_reference :users, :honest_broker, index: true, after: :net_id
    add_foreign_key :users, :groups, column: :honest_broker_id

    remove_column :users, :honest_broker
  end

  def down
    add_column :users, :honest_broker, :integer, after: :net_id
    remove_foreign_key :users, :groups
    remove_reference :users, :honest_broker, index: true
    drop_table :groups
  end
end
