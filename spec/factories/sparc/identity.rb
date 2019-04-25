FactoryBot.define do
  factory :sparc_identity, class: "SPARC::Identity" do
    first_name            { Faker::Name.unique.first_name }
    last_name             { Faker::Name.unique.last_name }
    email                 { Faker::Internet.unique.user_name + "@" + Directory.domain }
    ldap_uid              { email }
    password              { 'password' }
    password_confirmation { 'password' }
  end
end
