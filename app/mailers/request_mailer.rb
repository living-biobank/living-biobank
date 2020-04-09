class RequestMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: ENV.fetch('NO_REPLY_EMAIL')

  def confirmation_email
    @user     = params[:user]
    @request  = params[:request]

    mail(to: @request.primary_pi.email, cc: @user.email, subject: t(:mailers)[:request_mailer][:confirmation_email][:subject])
  end

  def submission_email
    @requester  = params[:requester]
    @request    = params[:request]

    mail(to: ENV.fetch('ADMIN_EMAIL'), from: ENV.fetch('REPLY_EMAIL'), subject: t(:mailers)[:request_mailer][:submission_email][:subject])
  end

  def manager_email
    @request = params[:request]

    mail(to: params[:email], subject: t(:mailers)[:request_mailer][:manager_email][:subject])
  end

  def completion_email
    @completer  = params[:completer]
    @request    = params[:request]

    mail(to: User.data_honest_brokers.pluck(:email), subject: t(:mailers)[:request_mailer][:completion_email][:subject])
  end
end
