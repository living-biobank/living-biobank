RSpec.configure do |config|
  config.before(:each) do
    create(:group, :with_source, :with_additional_service)
  end
end
