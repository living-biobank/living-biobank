class RequestMailer < ApplicationMailer
  def confirmation_email
    @user     = params[:user]
    @request  = params[:request]

    mail(to: @request.requester.email, cc: @user.email, subject: t(:mailers)[:request_mailer][:confirmation_email][:subject])
  end

  def pi_email
    @user     = params[:user]
    @request  = params[:request]

    mail(to: @request.primary_pi.email, subject: t(:mailers)[:request_mailer][:confirmation_email][:subject])
  end

  def manager_email
    @request  = params[:request]
    @user     = params[:user]

    mail(to: @user.email, subject: t(:mailers)[:request_mailer][:manager_email][:subject])
  end

  def admin_update_email
    @request  = params[:request]
    @user     = params[:user]

    mail(to: @user.email, subject: t('mailers.request_mailer.admin_update_email.subject'))
  end

  def finalization_email
    @request  = params[:request]
    @group    = params[:group]

    mail(to: @group.finalize_email_to, subject: t(''))
  end

  def completion_email
    @completer  = params[:completer]
    @request    = params[:request]

    mail(to: User.data_honest_brokers.pluck(:email), subject: t(:mailers)[:request_mailer][:completion_email][:subject])
  end
end
