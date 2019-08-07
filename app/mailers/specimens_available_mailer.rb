class SpecimensAvailableMailer < ApplicationMailer
  default from: ENV.fetch('NO_REPLY_EMAIL')

  def available_email (group)
    hb_email = group.honest_brokers.pluck(:email).join(', ')
        
    mail(to: hb_email, subject: t(:mailers)[:specimens_available_mailer][:available_email][:subject])
  end
end
