class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: ENV.fetch('LBB_EMAIL')

  layout 'mailer'
end
