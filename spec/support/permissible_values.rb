RSpec.configure do |config|
  config.before(:each) do
    allow(SPARC::PermissibleValue).to(
      receive(:get_hash).with('funding_status').
      and_return({
        'funded' => 'Funded',
        'pending_funding' => 'Pending Funding'
      })
    )

    allow(SPARC::PermissibleValue).to(
      receive(:get_hash).with('funding_source').
      and_return({
        'college' => 'College Department',
        'federal' => 'Federal',
        'foundation' => 'Foundation/Organization',
        'industry' => 'Industry-Initiated/Industry-Sponsored',
        'investigator' => 'Investigator-Initiated/Industry-Sponsored',
        'internal' => 'Internal Funded Pilot Project',
        'unfunded' => 'Student Funded Research'
      })
    )

    allow(SPARC::PermissibleValue).to(
      receive(:get_inverted_hash).with('funding_status').
      and_return({
        'Funded' => 'funded',
        'Pending Funding' => 'pending_funding'
      })
    )

    allow(SPARC::PermissibleValue).to(
      receive(:get_inverted_hash).with('funding_source').
      and_return({
        'College Department' => 'college',
        'Federal' => 'federal',
        'Foundation/Organization' => 'foundation',
        'Industry-Initiated/Industry-Sponsored' => 'industry',
        'Investigator-Initiated/Industry-Sponsored' => 'investigator',
        'Internal Funded Pilot Project' => 'internal',
        'Student Funded Research' => 'unfunded'
      })
    )
  end
end
