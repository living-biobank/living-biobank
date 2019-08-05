RSpec.configure do |config|
  config.before(:each) do
    allow(SPARC::Setting).to receive(:get_value).with('finished_statuses').and_return(%w(completed withdrawn))
  end
end
