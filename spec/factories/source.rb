FactoryBot.define do
  factory :source do
    key   { Faker::Lorem.word }
    value { Faker::Lorem.sentence(3) }
  end
end
