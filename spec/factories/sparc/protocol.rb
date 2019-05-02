FactoryBot.define do
  factory :sparc_protocol, class: "SPARC::Protocol" do
    type                      { %w(Project Study).sample }
    short_title               { Faker::Lorem.unique.sentence(3, false, 2) }
    title                     { Faker::Lorem.unique.sentence(5, false, 5) }
    brief_description         { Faker::Lorem.paragraph(1, false, 2) }
    funding_status            { SPARC::PermissibleValue.get_hash('funding_status').keys.sample }
    funding_source            { SPARC::PermissibleValue.get_hash('funding_source').keys.sample }
    potential_funding_source  { SPARC::PermissibleValue.get_hash('funding_source').keys.sample }
    start_date                { Date.today }
    end_date                  { Date.today + 1.year }

    trait :study do
      type { 'Study' }
    end

    trait :project do
      type { 'Project' }
    end

    trait :funded do
      funding_status { 'funded' }
      funding_source { SPARC::PermissibleValue.get_hash('funding_source').keys.sample }
    end

    trait :pending do
      funding_status            { 'pending_funding' }
      potential_funding_source  { SPARC::PermissibleValue.get_hash('funding_source').keys.sample }
    end

    before :create do |protocol, evaluator|
      protocol.primary_pi         = evaluator.primary_pi ? evaluator.primary_pi : create(:sparc_identity)
      protocol.project_roles     << create(:sparc_primary_pi, identity: protocol.primary_pi)
    end

    factory :sparc_study, class: "SPARC::Study", traits: [:study]
    factory :sparc_project, class: "SPARC::Project", traits: [:project]
  end
end
