namespace :email_tasks do
  desc "Check for available specimens and send email"
  task daily_specimen_check: :environment do
    @groups = Group.all
    @groups.each do |group|
      if group.labs.where(status: (I18n.t(:labs)[:statuses][:available])).any?
  		  SpecimensAvailableMailer.available_email(group).deliver_now
      end
    end
  end
end
