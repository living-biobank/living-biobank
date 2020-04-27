class SpecimenMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def release_email
    @specimen = params[:specimen]
    @group    = @specimen.group
    @request  = params[:request]
    @user     = @request.requester

    mail(to: @user.email, subject: t("mailers.specimen_mailer.release_email.#{@group.notify_when_all_specimens_released? ? 'subject_batch' : 'subject_individual'}"))
  end

  def discard_email
    @specimen = params[:specimen]
    @group    = @specimen.group
    @request  = params[:request]
    @user     = @request.requester

    mail(to: @user.email, subject: t(:mailers)[:specimen_mailer][:discard_email][:subject])
  end
end
