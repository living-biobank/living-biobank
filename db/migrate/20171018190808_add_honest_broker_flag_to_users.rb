class AddHonestBrokerFlagToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :honest_broker, :boolean, default: false, after: :net_id
  end
end
