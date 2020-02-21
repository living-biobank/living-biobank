class AddAppNameToEmailSubject
  def self.delivering_email(mail)
    prefixes  = []
    prefixes << I18n.t('site_information.name')
    prefixes << Rails.env.upcase unless Rails.env.production?
    prefix    = "[#{prefixes.join(' ')}] "
    mail.subject.prepend(prefix)
  end
end

ActionMailer::Base.register_interceptor(AddAppNameToEmailSubject)
