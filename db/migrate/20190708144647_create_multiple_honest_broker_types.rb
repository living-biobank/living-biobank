class CreateMultipleHonestBrokerTypes < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :honest_broker, :bigint, default: 0
  end
end
