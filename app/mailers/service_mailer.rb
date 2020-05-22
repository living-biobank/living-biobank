class ServiceMailer < ApplicationMailer
  def locked_email
    @line_item            = params[:line_item]
    @sub_service_request  = params[:sub_service_request]
    @user                 = params[:user]

    to = @user.present? ? @user.email : params[:to]

    mail(to: to, subject: t('mailers.service_mailer.locked_email.subject'))
  end
end
