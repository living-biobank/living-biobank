namespace :email_tasks do
  desc "Check for available specimens and send email"
  task daily_specimen_check: :environment do
  	SpecimensAvailableMailer.available_email.deliver_now
  end

end
