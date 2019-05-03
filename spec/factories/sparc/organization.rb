FactoryBot.define do
  factory :sparc_organization, class: "SPARC::Organization" do
    type { %w(Institution Provider Program Core).sample }

    trait :institution do
      type { 'Institution' }
    end

    trait :provider do
      type { 'Provider' }
    end

    trait :program do
      type { 'Program' }
    end

    trait :core do
      type { 'Core' }
    end

    trait :process_ssrs do
      process_ssrs { true }
    end

    before :create do |organization, evaluator|
      case organization.type
      when 'Provider'
        organization.parent = evaluator.parent ? evaluator.parent : create(:sparc_institution, :process_ssrs)
      when 'Program'
        organization.parent = evaluator.parent ? evaluator.parent : create(:sparc_provider, :process_ssrs)
      when 'Core'
        organization.parent = evaluator.parent ? evaluator.parent : create(:sparc_program, :process_ssrs)
      end
    end

    factory :sparc_institution, traits: [:institution]
    factory :sparc_provider,    traits: [:provider]
    factory :sparc_program,     traits: [:program]
    factory :sparc_core,        traits: [:core]
  end
end
