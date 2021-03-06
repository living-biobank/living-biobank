namespace :email_tasks do
  desc "Check for available specimens and send email"
  task daily_specimen_check: :environment do
    Group.all.each do |group|
      if group.labs.where(status: 'available').any?
        group.lab_honest_broker_users.each do |lhb|
  		    SpecimenMailer.with(user: lhb, group: group).available_email.deliver_now
        end
      end
    end
  end
end
