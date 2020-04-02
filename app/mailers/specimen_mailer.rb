class SpecimenMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: ENV.fetch('REPLY_EMAIL')

  def release_email
    @group    = params[:group]
    @request  = params[:request]
    @user     = @request.requester

    mail(to: @user.email, subject: t(:mailers)[:specimen_mailer][:release_email][:subject])
  end

  def discard_email
    @group    = params[:group]
    @request  = params[:request]
    @user     = @request.requester

    mail(to: @user.email, subject: t(:mailers)[:specimen_mailer][:discard_email][:subject])
  end
end
