class RequestMailer < ApplicationMailer
  default from: ENV.fetch('NO_REPLY_EMAIL')

  def confirmation_email
    @user     = params[:user]
    @request  = params[:request]

    mail(to: @request.primary_pi_email, cc: @user.email, subject: t(:mailers)[:request_mailer][:confirmation_email][:subject])
  end
end
