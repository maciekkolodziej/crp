require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Crp
  WEEKDAYS = {pl: ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela'], en: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']}
  MONTHS = {pl: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'], 
            en: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']}
  
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :pl
    
    config.generators do |g|
      g.template_engine :haml
    end
    config.encoding = "UTF-8"
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    config.autoload_paths += Dir[Rails.root.join('lib', '{**}')]
    
    # Don't care if the mailer can't send.
    # config.action_mailer.raise_delivery_errors = false
    config.action_mailer.raise_delivery_errors = true
    
    config.secret_key_base = ENV['SECRET_TOKEN']
    
    # Config mailer
    config.action_mailer.delivery_method = :smtp
    pass_file = Rails.root.join('config', 'passwords', 'smtp.pass')
    smtp_pass = File.open(pass_file, "r").read
    config.action_mailer.smtp_settings = {
      address:              'maciekkolodziej.pl',
      port:                 587,
      domain:               'maciekkolodziej.pl',
      user_name:            'crp',
      password:             ENV['SMTP_PASS'],
      authentication:       'plain',
      enable_starttls_auto: true  }
    
    # Locales
    config.i18n.available_locales = [:en, :pl]
    
    # Precompile additional assets.
    # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
    config.assets.precompile += %w( search.js, *.js, *.scss, *.coffee, *.css, *.css.erb)
  end
end
