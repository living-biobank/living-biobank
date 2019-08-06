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
      honest_broker_id { Group.first.try(:id) || create(:group).id }
    end

    before :create do |user|
      create(:sparc_identity, first_name: user.first_name, last_name: user.last_name, email: user.email, ldap_uid: user.net_id)
    end

    factory :honest_broker, traits: [:honest_broker]
  end
end
