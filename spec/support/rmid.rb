RSpec.configure do |config|
  config.before(:each) do
    stub_rmid
  end
end

def stub_rmid(enabled: true, has_record: true)
  allow(SPARC::Setting).to receive(:get_value).with('research_master_enabled').and_return(enabled)
  allow(SPARC::Setting).to receive(:get_value).with('research_master_api').and_return('http://rmid.api.edu/')
  allow(SPARC::Setting).to receive(:get_value).with('rmid_api_token').and_return('J.R.R. Tolkien')

  if enabled
    allow(HTTParty).to receive(:get).
      with(/#{Regexp.quote(SPARC::Setting.get_value('research_master_api'))}research_masters\/.+\.json/, anything()).
      and_return(has_record ? {'long_title' => 'A long title', 'short_title' => 'A short title'} : {'status' => 404})
  end
end
