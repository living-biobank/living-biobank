FactoryBot.define do
  factory :user do
    first_name            { Faker::Name.unique.first_name }
    last_name             { Faker::Name.unique.last_name }
    email                 { Faker::Internet.unique.user_name + "@" + Directory.domain }
    net_id                { email }
    password              { 'password' }
    password_confirmation { 'password' }
    honest_broker         { false }

    trait :honest_broker do
      honest_broker { true }
    end

    factory :honest_broker, traits: [:honest_broker]
  end
end
