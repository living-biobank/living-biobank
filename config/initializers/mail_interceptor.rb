class MailInterceptor
  def self.delivering_email(mail)
    prefixes  = []
    prefixes << I18n.t('site_information.title.base')
    prefixes << Rails.env.upcase unless Rails.env.production?
    prefix    = "[#{prefixes.join(' ')}] "
    mail.subject.prepend(prefix)

    unless Rails.env.production?
      # mail.to = ENV.fetch('LBB_EMAIL')
      mail.to = 'etai@musc.edu, iboto1@gmail.com, excelsior2276@yahoo.com'
      mail.cc = nil
    end
  end
end

ActionMailer::Base.register_interceptor(MailInterceptor)
