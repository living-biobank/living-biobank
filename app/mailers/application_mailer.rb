class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('LBB_EMAIL')

  layout 'mailer'
end
