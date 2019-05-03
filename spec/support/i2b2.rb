RSpec.configure do |config|
  config.before(:each) do
    empty_set = I2b2::QueryName.none
    results   = [I2b2::QueryName.new(name: 'Test Query 1')]
    allow(empty_set).to receive(:order).with(anything).and_return(results)
    allow(I2b2::QueryName).to receive(:where).with(anything).and_return(empty_set)
    allow(I2b2::QueryName).to receive(:first).and_return(results[0].name)
  end
end
