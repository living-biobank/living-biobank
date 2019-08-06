FactoryBot.define do
  factory :group do
    name                        { Faker::Lorem.word }
    process_specimen_retrieval  { true }
    process_sample_size         { true }
    display_patient_information { true }

    trait :with_source do
      after :create do |group, evaluator|
        create(:source, group: group)
      end
    end

    trait :with_additional_service do
      after :create do |group, evaluator|
        create(:service, group: group)
      end
    end
  end
end
