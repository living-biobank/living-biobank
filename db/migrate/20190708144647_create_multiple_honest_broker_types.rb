class CreateMultipleHonestBrokerTypes < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :honest_broker, :integer, default: 0
  end
end
