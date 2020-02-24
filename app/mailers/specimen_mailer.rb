class SpecimenMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: ENV.fetch('NO_REPLY_EMAIL')

  def release_email(request)
    @study = request.protocol.title
    @study_type = request.protocol.type
    mail(to: request.primary_pi.email, subject: t(:mailers)[:specimen_mailer][:release_email][:subject])
  end
end
