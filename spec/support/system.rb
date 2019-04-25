Dir[Rails.root.join('spec', 'support', 'system', '*.rb')].each{ |f| require f }

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by(ENV['HEADLESS'] ? :selenium_headless : :selenium)
  end

  config.include System::SOS, type: :system
end
