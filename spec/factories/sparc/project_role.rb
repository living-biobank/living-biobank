FactoryBot.define do
  factory :sparc_project_role, class: "SPARC::ProjectRole" do
    project_rights  { Faker::Lorem.word }
    role            { Faker::Lorem.word }

    trait :primary_pi do
      role            { 'primary-pi' }
      project_rights  { 'approve' }
    end

    factory :sparc_primary_pi, traits: [:primary_pi]
  end
end
