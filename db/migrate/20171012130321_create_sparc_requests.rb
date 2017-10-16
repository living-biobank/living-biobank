class CreateSparcRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :sparc_requests do |t|
      t.string :short_title
      t.text :title
      t.string :funding_status
      t.string :funding_source
      t.date :start_date
      t.date :end_date
      t.string :primary_pi_netid
      t.string :primary_pi_name
      t.string :primary_pi_email

      t.timestamps
    end
  end
end
