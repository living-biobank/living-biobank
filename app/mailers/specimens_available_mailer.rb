class SpecimensAvailableMailer < ApplicationMailer
  default from: ENV.fetch('NO_REPLY_EMAIL')

  def available_email(lab_honest_broker, group)
    @lab_honest_broker  = lab_honest_broker
    @group              = group

    mail(to: lab_honest_broker.email, subject: t('mailers.specimens_available_mailer.available_email.subject', group: group.name))
  end
end
