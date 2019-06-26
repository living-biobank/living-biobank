class ReleaseSpecimenMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: ENV.fetch('NO_REPLY_EMAIL')

  def release_email(primary_pi, request)
    @study = request.protocol.title
    @study_type = request.protocol.type
    mail(to: primary_pi.email, subject: t(:mailers)[:release_specimen_mailer][:release_email][:subject])
  end
end
