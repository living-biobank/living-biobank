RSpec.configure do |config|
  config.before(:each) do
    allow(SPARC::Setting).to receive(:get_value).with('use_ldap').and_return(false)
  end
end
