class RequestMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: ENV.fetch('NO_REPLY_EMAIL')

  def confirmation_email
    @user     = params[:user]
    @request  = params[:request]

    mail(to: @request.primary_pi_email, cc: @user.email, subject: t(:mailers)[:request_mailer][:confirmation_email][:subject])
  end

  def submission_email
    @request = params[:request]

    mail(to: ENV.fetch('ADMIN_EMAIL'), subject: t(:mailers)[:request_mailer][:submission_email][:subject])
  end
end