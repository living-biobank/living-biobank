class SpecimensAvailableMailer < ApplicationMailer
  default from: ENV.fetch('NO_REPLY_EMAIL')

  def available_email
    if Lab.where(status: 'Available').any?
      @honest_brokers = User.all.where(honest_broker: true)
      hb_email = @honest_brokers.collect(&:email).join(", ")
        
      mail(to: hb_email, subject: t(:mailers)[:specimens_available_mailer][:available_email][:subject])
    end
  end
end
