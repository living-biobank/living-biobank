class CreateLabHonestBrokers < ActiveRecord::Migration[5.1]
  def change
    #create new table
    unless ActiveRecord::Base.connection.table_exists?('lab_honest_brokers')
      create_table :lab_honest_brokers do |t|
        t.references :user, foreign_key: true
        t.references :group, foreign_key: true
      end
    end

    #transfer honest broker data to new table
    @users = User.all
    @users.each do |user|
      if user.honest_broker_id.present?
        user.groups << Group.find(user.honest_broker_id)
      end
    end

    #remove honest broker option from users table
    if foreign_key_exists?(:users, column: :honest_broker_id)
      remove_foreign_key :users, column: :honest_broker_id
    end

    remove_column :users, :honest_broker_id
  end
end
