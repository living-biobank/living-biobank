class SpecimensAvailableMailer < ApplicationMailer
  def available_email
    @user   = params[:user]
    @group  = params[:group]

    mail(to: @user.email, subject: t('mailers.specimens_available_mailer.available_email.subject', group: @group.name))
  end
end
