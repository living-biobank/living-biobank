require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SparcBiobank
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.i18n.default_locale = :en
    config.i18n.available_locales = %(en)

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    config.active_job.queue_adapter = :delayed_job

    config.action_dispatch.default_headers.merge!({'Vary' => 'Accept', 'X-Frame-Options' => 'ALLOWALL', 'X-UA-Compatible' => 'IE=edge,chrome=1'})
  end
end
