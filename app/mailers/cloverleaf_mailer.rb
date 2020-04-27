class RequestMailer < ApplicationMailer
  def job_error
    @lab        = params[:lab]
    @job        = params[:job]
    @exception  = params[:exception]

    mail(to: ENV.fetch('ADMIN_EMAIL'), subject: t(:mailers)[:cloverleaf_mailer][:job_error][:subject])
  end

  def job_failure
    @lab = params[:lab]
    @job = params[:job]

    mail(to: ENV.fetch('ADMIN_EMAIL'), subject: t(:mailers)[:cloverleaf_mailer][:job_failure][:subject])
  end
end
