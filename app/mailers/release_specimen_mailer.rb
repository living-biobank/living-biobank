class ReleaseSpecimenMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: ENV.fetch('NO_REPLY_EMAIL')

  def release_email(primary_pi, study)
    @study = study
    mail(to: primary_pi.email, subject: t(:mailers)[:release_specimen_mailer][:release_email][:subject])
  end
end
