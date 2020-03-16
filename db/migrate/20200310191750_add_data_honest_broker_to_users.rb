class AddDataHonestBrokerToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :data_honest_broker, :boolean, default: false, after: :admin
  end
end
