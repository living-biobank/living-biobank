FactoryBot.define do
  factory :sparc_protocol, class: "SPARC::Protocol" do
    type                      { 'Project' }
    short_title               { Faker::Lorem.unique.sentence(3, false, 2) }
    title                     { Faker::Lorem.unique.sentence(5, false, 5) }
    brief_description         { Faker::Lorem.paragraph(1, false, 2) }
    funding_status            { %w(funded pending_funding).sample }
    funding_source            { Faker::Lorem.word }
    potential_funding_source  { Faker::Lorem.word }
    start_date                { Date.today }
    end_date                  { Date.today + 1.year }

    trait :funded do
      funding_status { 'funded' }
      funding_source { Faker::Lorem.word }
    end

    trait :pending do
      funding_status            { 'pending_funding' }
      potential_funding_source  { Faker::Lorem.word }
    end

    before :create do |protocol, evaluator|
      protocol.primary_pi         = evaluator.primary_pi ? evaluator.primary_pi : create(:sparc_identity)
      protocol.project_roles     << create(:sparc_primary_pi, identity: protocol.primary_pi)
    end
  end
end
